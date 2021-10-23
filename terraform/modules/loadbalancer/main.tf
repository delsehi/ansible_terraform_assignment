terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

# Create loadbalancer
resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  name          = "loadbalancer"
  vip_subnet_id = var.subnet_1.id

  security_group_ids = [
    var.http_secgroup.id
  ]
}

# Create a listener for loadbalancer
resource "openstack_lb_listener_v2" "listener" {
  name            = "listener"
  protocol        = "HTTP"
  protocol_port   = "80"
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

# Create loadbalancer pool
resource "openstack_lb_pool_v2" "pool" {
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.listener.id
}

# Create loadbalancer member from each wordpress instance and
# add them to the loadbalancer pool
resource "openstack_lb_member_v2" "member" {
  count     = var.wp_instances
  pool_id   = openstack_lb_pool_v2.pool.id
  subnet_id = var.subnet_1.id

  address       = var.wordpress[count.index].access_ip_v4
  protocol_port = 80
}

# Create floating ip and connect to loadbalancer
resource "openstack_networking_floatingip_v2" "loadbalancer_fip" {
  pool    = "public"
  port_id = openstack_lb_loadbalancer_v2.loadbalancer.vip_port_id

  depends_on = [
    # openstack_lb_listener_v2.listener
  ]
}

# output "loadbalancer_ip" {
#   value       = var.loadbalancer_floating_ip.address
#   description = "ip of loadbalancer"
# }
