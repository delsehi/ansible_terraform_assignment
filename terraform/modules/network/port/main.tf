terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

resource "openstack_networking_port_v2" "port" {
  name       = var.name
  network_id = var.network_id

  fixed_ip {
    subnet_id = var.subnet_id
  }
}
