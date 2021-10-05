terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}
variable "keypair" {
  type    = string
  default = "ds222qe_Keypair" # name of keypair created 
}
variable "network" {
  type    = string
  default = "private" # default network to be used
}

variable "security_groups" {
  type    = list(string)
  default = ["default"] # Name of default security group
}

# Network
resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "192.168.199.0/24"
  ip_version = 4
}

resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "a security group"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_port_v2" "port_1" {
  name               = "port_1"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    subnet_id  = "${openstack_networking_subnet_v2.subnet_1.id}"
    ip_address = "192.168.199.10"
  }
}


# Create an instance
resource "openstack_compute_instance_v2" "server" {
  name            = "server"
#   image_id        = "1b20a5d7-8ec1-4c2e-af0e-6175d361b680"
  image_name = "Ubuntu Minimal 18.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair        = var.keypair
  security_groups = var.security_groups

  network {
    port = "${openstack_networking_port_v2.port_1.id}"
  }
}