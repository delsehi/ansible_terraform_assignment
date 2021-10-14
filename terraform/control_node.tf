# Declare variables needed to install and configure Ansible on control node
locals {
  install_ansible = {
    private_key    = file(var.private_key),
    public_key     = file(var.public_key),
    master_db_ip   = openstack_compute_instance_v2.db_master.network[0].fixed_ip_v4,
    slave_db_ip    = openstack_compute_instance_v2.db_slave.network[0].fixed_ip_v4,
    file_server_ip = openstack_compute_instance_v2.file_server.network[0].fixed_ip_v4
    wp_nodes       = openstack_compute_instance_v2.wordpress,
    access_token   = var.git_access_token,
    api_url        = var.git_api_url,
  }
}

# Create control node
resource "openstack_compute_instance_v2" "control_node" {
  name              = "control_node"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = var.keypair
  security_groups   = [ "default", openstack_networking_secgroup_v2.ssh_secgroup.id ]

  network {
    port = openstack_networking_port_v2.control_node_port.id
  }

  user_data = templatefile("./templates/cn_config.tpl", local.install_ansible)
}

# Outputs the floating ip of the control node
output "public_ip" {
  value       = openstack_networking_floatingip_v2.fip_1.address
  description = "The public ip address of the server"
}