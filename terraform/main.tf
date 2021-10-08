terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}
variable "keypair" {
  type = string # Set this value in terraform.tfvars
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
  name                = "public_router"
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

# Create the control node for Ansible
resource "openstack_compute_instance_v2" "control_node" {
  name              = "control_node"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = var.keypair
  security_groups   = ["default", "${openstack_compute_secgroup_v2.ssh_secgroup.id}"]

  network {
    name = "network_1"
  }

  # User data is run at startup. This template contains the cloud-init
  user_data = data.template_cloudinit_config.config.rendered

}

# Public IP for the control node
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = openstack_networking_floatingip_v2.fip_1.address
  instance_id = openstack_compute_instance_v2.control_node.id
}
# CLOUD INIT
# This makes a template from cn_config.tpl and adds the ip adresses
# for Ansible's inventory in /etc/ansible/hosts
data "template_file" "script" {
  template = "${file("templates/cn_config.tpl")}"
  vars = {
    # The id of the MariaDB server created below
    master_db_ip = openstack_compute_instance_v2.db_master.network[0].fixed_ip_v4
  }
}
data "template_cloudinit_config" "config" {
  gzip = false
  base64_encode = false
  part {
    filename = "init.cfg"
    content_type = "text/cloud-config"
    content = "${data.template_file.script.rendered}"
  }
}

# MariaDB Master node 
resource "openstack_compute_instance_v2" "db_master" {
  name              = "db_master"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = var.keypair
  security_groups   = ["default", "${openstack_compute_secgroup_v2.ssh_secgroup.id}"]
  network {
    name = "network_1"
  }
}


output "public_ip" {
  value       = openstack_networking_floatingip_v2.fip_1.address
  description = "The public ip address of the server"
}
output "master_db_ip" {
  value = openstack_compute_instance_v2.db_master.network[0].fixed_ip_v4
  description = "Internal ip of MariaDB master node"
  
}