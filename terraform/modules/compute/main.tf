terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

resource "openstack_compute_instance_v2" "compute" {
  name              = var.name
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  # key_pair          = var.keypair

  # security_groups = var.secgroups

  network {
    port = var.port_id
  }
}
