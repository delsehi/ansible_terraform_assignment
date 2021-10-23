terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = "public"
}

resource "openstack_networking_floatingip_associate_v2" "floating_ip_associate" {
  floating_ip = openstack_networking_floatingip_v2.floating_ip.address
  port_id     = var.port_id
}
