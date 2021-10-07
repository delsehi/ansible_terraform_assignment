terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}
variable "keypair" {
  type    = string # Set this value in terraform.tfvars
}


variable "security_groups" {
  type    = list(string)
  default = ["default"] # Name of default security group
}

# Network
data "openstack_networking_network_v2" "public_network" {
  name = "public"
}

resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.199.0/24"
  ip_version = 4
}

resource "openstack_networking_router_v2" "public_router" {
    name = "public_router"
    external_network_id = data.openstack_networking_network_v2.public_network.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
    router_id = openstack_networking_router_v2.public_router.id
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
}

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

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}

# Create an instance
resource "openstack_compute_instance_v2" "control_node" {
  name = "control_node"
  image_name        = "Ubuntu Minimal 18.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = var.keypair
  security_groups   = ["default", "${openstack_compute_secgroup_v2.ssh_secgroup.id}"]

  network {
   name = "network_1"
  }

  user_data = "${file("install-ansible.sh")}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.control_node.id}"
}

output "public_ip" {
    value = openstack_networking_floatingip_v2.fip_1.address
    description = "The public ip address of the server"
}