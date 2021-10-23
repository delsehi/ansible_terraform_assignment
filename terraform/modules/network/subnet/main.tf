terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

resource "openstack_networking_subnet_v2" "subnet" {
  name       = var.name
  network_id = var.network_id
  cidr       = var.cidr
  ip_version = 4
}
