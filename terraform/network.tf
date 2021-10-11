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
  cidr       = "192.168.199.0/24"
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

# Create ssh security group
resource "openstack_compute_secgroup_v2" "ssh_secgroup" {
  name        = "ssh_secgroup"
  description = "sceurity group for ssh, opens port 22 for tcp"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
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