terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

data "openstack_compute_keypair_v2" "default_keypair" {
  name = var.keypair
}

# Create wordpress server instances
resource "openstack_compute_instance_v2" "wordpress" {
  count             = var.wp_instances
  name              = "wordpress_${count.index + 1}"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = data.openstack_compute_keypair_v2.default_keypair.id

  security_groups = [
    var.ssh_secgroup.name,
    var.http_secgroup.name
  ]

  network {
    # port = var.ports.wordpress_ports[count.index].id
    uuid = var.network.id
  }

  depends_on = [
    var.router_interface,
    # openstack_lb_pool_v2.pool
  ]
}

# Create database master node
resource "openstack_compute_instance_v2" "db_master" {
  name              = "db_master"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = data.openstack_compute_keypair_v2.default_keypair.id

  security_groups = [
    var.ssh_secgroup.name
  ]

  network {
    # port = var.ports.database_ports[0].id
    uuid = var.network.id
  }

  depends_on = [
    var.router_interface
  ]
}

# Create database slave node
resource "openstack_compute_instance_v2" "db_slave" {
  name              = "db_slave"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = data.openstack_compute_keypair_v2.default_keypair.id

  security_groups = [
    var.ssh_secgroup.name
  ]

  network {
    # port = var.ports.database_ports[1].id
    uuid = var.network.id
  }

  depends_on = [
    var.router_interface
  ]
}

# Create file server
resource "openstack_compute_instance_v2" "file_server" {
  name              = "file_server"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = data.openstack_compute_keypair_v2.default_keypair.id

  security_groups = [
    var.ssh_secgroup.name
  ]

  network {
    # port = var.ports.fileserver_port.id
    uuid = var.network.id
  }

  depends_on = [
    var.router_interface
  ]
}
