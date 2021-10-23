terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = var.router_id
  subnet_id = var.subnet_id
}
