terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  name               = var.name
  vip_subnet_id      = var.subnet_id
  security_group_ids = var.secgroup_ids
}

resource "openstack_lb_listener_v2" "listener" {
  name            = "listener"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_pool_v2" "pool" {
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.listener.id
}

resource "openstack_lb_member_v2" "member" {
  count         = length(var.members)
  pool_id       = openstack_lb_pool_v2.pool.id
  subnet_id     = var.subnet_id
  address       = var.members[count.index]
  protocol_port = 80
}
