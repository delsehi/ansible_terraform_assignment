terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

data "openstack_networking_secgroup_v2" "default_secgroup" {
  name = "default"
}

resource "openstack_networking_port_v2" "port" {
  name       = var.name
  network_id = var.network_id

  fixed_ip {
    subnet_id = var.subnet_id
  }

  security_group_ids = concat(
    [data.openstack_networking_secgroup_v2.default_secgroup.id],
    var.secgroup_ids
  )
}
