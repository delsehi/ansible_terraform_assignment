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

resource "openstack_networking_network_v2" "network" {
  name = "network_${var.name}"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name       = "subnet_${var.name}"
  network_id = openstack_networking_network_v2.network.id
  cidr       = var.cidr
  ip_version = 4
}

resource "openstack_networking_router_v2" "router" {
  name                = "router_${var.name}"
  external_network_id = data.openstack_networking_network_v2.public_network.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}
