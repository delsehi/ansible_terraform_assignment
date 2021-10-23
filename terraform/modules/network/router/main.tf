terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

data "openstack_networking_network_v2" "public_network" {
  name = "public"
}

resource "openstack_networking_router_v2" "router" {
  name                = var.name
  external_network_id = data.openstack_networking_network_v2.public_network.id
}
