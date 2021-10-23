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

# Create control node
resource "openstack_compute_instance_v2" "control_node" {
  name              = "control_node"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = data.openstack_compute_keypair_v2.default_keypair.id

  security_groups = [
    var.ssh_secgroup.name
  ]

  network {
    # port = var.ports.control_node_port.id
    uuid = var.network.id
  }

  depends_on = [
    var.router_interface
  ]

  user_data = templatefile("./modules/control_node/templates/cn_config.tpl", local.install_ansible)
}
