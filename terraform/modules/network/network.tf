# Get the id of the public network
data "openstack_networking_network_v2" "public_network" {
  name = "public"
}

# Get the id of the key pair
data "openstack_compute_keypair_v2" "default_keypair" {
  name = var.keypair
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

##############################################################
# Floating ips are defined and associated to compute instances
# or network resources
##############################################################

# Create a floating ip for control node
resource "openstack_networking_floatingip_v2" "control_node_fip" {
  pool = "public"
}

# # Create floating ip and connect to loadbalancer
# resource "openstack_networking_floatingip_v2" "loadbalancer_fip" {
#   pool    = "public"
#   port_id = var.loadbalancer.vip_port_id

#   depends_on = [
#     # openstack_lb_listener_v2.listener
#   ]
# }

# Connect floating ip to control node
resource "openstack_networking_floatingip_associate_v2" "fip_1" {
  floating_ip = openstack_networking_floatingip_v2.control_node_fip.address
  # port_id     = openstack_networking_port_v2.control_node_port.id
  # port_id = var.control_node.network[0].port
  port_id = "54b46c91-8c09-47d7-bf9e-4aef58feb5a0"

  depends_on = [
    # openstack_compute_instance_v2.control_node
  ]
}
