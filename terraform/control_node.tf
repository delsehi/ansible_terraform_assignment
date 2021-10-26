# Declare variables needed to install and configure Ansible on control node
locals {
  install_ansible = {
    private_key    = file(var.private_key_formatted),
    public_key     = file(var.public_key),
    master_db_ip   = openstack_compute_instance_v2.db_master.network[0].fixed_ip_v4,
    slave_db_ip    = openstack_compute_instance_v2.db_slave.network[0].fixed_ip_v4,
    file_server_ip = openstack_compute_instance_v2.file_server.network[0].fixed_ip_v4
    wp_nodes       = openstack_compute_instance_v2.wordpress,
    access_token   = var.git_access_token,
    api_url        = var.git_api_url,
    # loadbalancer_fip = openstack_networking_floatingip_v2.loadbalancer_fip.address
  }
}

# Create control node
resource "openstack_compute_instance_v2" "control_node" {
  name              = "control_node"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = data.openstack_compute_keypair_v2.default_keypair.id

  network {
    port = openstack_networking_port_v2.control_node_port.id
  }

  depends_on = [
    openstack_networking_router_interface_v2.router_interface
  ]

  user_data = templatefile("./templates/cn_config.tpl", local.install_ansible)
}

# Transfer wordpress files to controll node
resource "null_resource" "transfer_wp" {

  provisioner "file" {
    source      = "./files/acme_wordpress_files.tar.gz"
    destination = "/home/ubuntu/acme_wordpress_files.tar.gz"
  }

  connection {
    host        = openstack_networking_floatingip_v2.control_node_fip.address
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key)
    agent       = "false"
  }

  depends_on = [
    openstack_networking_floatingip_associate_v2.fip_1,
  ]
}

# Transfer sql dump file to control node where ansible will use it
resource "null_resource" "transfer_backupsql" {

  provisioner "file" {
    source      = "./files/backup.sql"
    destination = "/home/ubuntu/backup.sql"
  }

  connection {
    host        = openstack_networking_floatingip_v2.control_node_fip.address
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key)
    agent       = "false"
  }

  depends_on = [
    openstack_networking_floatingip_associate_v2.fip_1,
  ]
}

# Transfer sql dump file to control node where ansible will use it
resource "null_resource" "transfer_xmlimport" {

  provisioner "file" {
    source      = "./files/acme.wordpress.2018-10-09.xml"
    destination = "/home/ubuntu/acme.wordpress.2018-10-09.xml"
  }

  connection {
    host        = openstack_networking_floatingip_v2.control_node_fip.address
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key)
    agent       = "false"
  }

  depends_on = [
    openstack_networking_floatingip_associate_v2.fip_1,
  ]
}

# Create local txt file with loadbalancer fip to send to control node
resource "local_file" "loadbalancer_fip" {
  content  = openstack_networking_floatingip_v2.loadbalancer_fip.address
  filename = "./files/loadbalancer_fip.txt"

  depends_on = [
    openstack_networking_floatingip_v2.loadbalancer_fip,
  ]
}

# Send loadbalancer fip file to control node
resource "null_resource" "transfer_loadbalancerfip" {

  provisioner "file" {
    source      = "./files/loadbalancer_fip.txt"
    destination = "/home/ubuntu/loadbalancer_fip.txt"
  }

  connection {
    host        = openstack_networking_floatingip_v2.control_node_fip.address
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key)
    agent       = "false"
  }

  depends_on = [
    local_file.loadbalancer_fip,
    openstack_networking_floatingip_associate_v2.fip_1
  ]
}

# Outputs the floating ip of the control node
output "public_ip" {
  value       = openstack_networking_floatingip_v2.control_node_fip.address
  description = "The public ip address of the server"
}
