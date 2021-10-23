terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = var.name
  description = "Security group for ${var.name}"
}

resource "openstack_networking_secgroup_rule_v2" "rule" {
  description       = "Security group rule for ${var.name}"
  direction         = var.direction
  ethertype         = "IPv4"
  protocol          = var.protocol
  port_range_min    = var.port_min
  port_range_max    = var.port_max
  remote_ip_prefix  = var.remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}
