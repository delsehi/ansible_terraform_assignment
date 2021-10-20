# Create database master node
resource "openstack_compute_instance_v2" "db_master" {
  name              = "db_master"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = data.openstack_compute_keypair_v2.default_keypair.id

  network {
    port = openstack_networking_port_v2.db_ports[0].id
  }

  depends_on = [
    openstack_networking_router_interface_v2.router_interface
  ]
}

# Create database slave node
resource "openstack_compute_instance_v2" "db_slave" {
  name              = "db_slave"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = data.openstack_compute_keypair_v2.default_keypair.id

  network {
    port = openstack_networking_port_v2.db_ports[1].id
  }

  depends_on = [
    openstack_networking_router_interface_v2.router_interface
  ]
}

# Transfer sql dump file to control node where ansible will use it
resource "null_resource" transfer_backupsql {

  provisioner "file" {
    source      = "./files/backup.sql"
    destination = "/home/ubuntu/backup.sql"
  }

  connection {
    host     = "${openstack_networking_floatingip_v2.control_node_fip.address}"
    type     = "ssh"
    user     = "ubuntu"
    private_key = file(var.private_key)
    agent    = "false"
  }

  depends_on = [
    openstack_networking_floatingip_associate_v2.fip_1,
  ]
}
