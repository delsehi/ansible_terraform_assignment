# Get the id of the public network
data "openstack_networking_network_v2" "public_network" {
  name = "public"
}

# Get the id of the default sec group
data "openstack_networking_secgroup_v2" "default_secgroup" {
  name = "default"
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

#################################################################
# Ports are created and connects compute instances to the network.
# The security groups to be used are also added to the ports.
##################################################################

# Create port for the control node
resource "openstack_networking_port_v2" "control_node_port" {
  name       = "control_node_port"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }

  security_group_ids = [
    openstack_networking_secgroup_v2.ssh_secgroup.id,
    data.openstack_networking_secgroup_v2.default_secgroup.id
  ]
}

# Create port for the file server
resource "openstack_networking_port_v2" "file_server_port" {
  name       = "file_server_port"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }

  security_group_ids = [
    openstack_networking_secgroup_v2.ssh_secgroup.id,
    data.openstack_networking_secgroup_v2.default_secgroup.id
  ]
}

# Create ports for wordpress instances
resource "openstack_networking_port_v2" "wp_ports" {
  count      = var.wp_instances
  name       = "wp_${count.index + 1}_port"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
  security_group_ids = [
    openstack_networking_secgroup_v2.ssh_secgroup.id,
    openstack_networking_secgroup_v2.http_secgroup.id,
    data.openstack_networking_secgroup_v2.default_secgroup.id
  ]
}

# Create ports for the databases
resource "openstack_networking_port_v2" "db_ports" {
  count      = 2
  name       = "db_${count.index + 1}_port"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }

  security_group_ids = [
    openstack_networking_secgroup_v2.ssh_secgroup.id,
    data.openstack_networking_secgroup_v2.default_secgroup.id,
    openstack_networking_secgroup_v2.db_secgroup.id
  ]
}

##############################################################
# Floating ips are defined and associated to compute instances
# or network resources
##############################################################

# Create a floating ip for control node
resource "openstack_networking_floatingip_v2" "control_node_fip" {
  pool = "public"
}

# Create floating ip and connect to loadbalancer
resource "openstack_networking_floatingip_v2" "loadbalancer_fip" {
  pool    = "public"
  port_id = openstack_lb_loadbalancer_v2.loadbalancer.vip_port_id

  depends_on = [
    openstack_lb_listener_v2.listener
  ]
}

# Connect floating ip to control node
resource "openstack_networking_floatingip_associate_v2" "fip_1" {
  floating_ip = openstack_networking_floatingip_v2.control_node_fip.address
  port_id     = openstack_networking_port_v2.control_node_port.id
}
