# Get the id of the public network
data "openstack_networking_network_v2" "public_network" {
  name = "public"
}

# Create a private network
resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}

# Create subnet for private network
resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = var.cidr
  ip_version = 4
}

# Create router
resource "openstack_networking_router_v2" "public_router" {
  name                = "public_router"
  external_network_id = data.openstack_networking_network_v2.public_network.id
}

# Connect public and private network through router
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.public_router.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}

resource "openstack_networking_port_v2" "loadbalancer_port" {
  name       = "port_loadbalancer"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

resource "openstack_networking_port_v2" "control_node_port" {
  name       = "port_control_node"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

resource "openstack_networking_port_v2" "file_server_port" {
  name       = "port_file_server"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

resource "openstack_networking_port_v2" "wp_ports" {
  count      = var.wp_instances
  name       = "port_wp_${count.index + 1}"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

resource "openstack_networking_port_v2" "db_ports" {
  count      = 2
  name       = "port_db_${count.index + 1}"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

# Create a floating ip
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}

# Connect floating ip to control node
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = openstack_networking_floatingip_v2.fip_1.address
  instance_id = openstack_compute_instance_v2.control_node.id
}
