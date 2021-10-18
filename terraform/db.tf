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
}
