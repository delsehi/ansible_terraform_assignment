# Create loadbalancer
resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  name          = "loadbalancer"
  vip_subnet_id = openstack_networking_subnet_v2.subnet_1.id

  security_group_ids = [
    openstack_networking_secgroup_v2.http_secgroup.id
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
  subnet_id = openstack_networking_subnet_v2.subnet_1.id

  address       = openstack_compute_instance_v2.wordpress[count.index].access_ip_v4
  protocol_port = 80
}

output "loadbalancer_ip" {
  value       = openstack_networking_floatingip_v2.loadbalancer_fip.address
  description = "ip of loadbalancer"
}
