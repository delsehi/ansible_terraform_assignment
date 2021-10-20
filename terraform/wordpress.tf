# Create wordpress server instances
resource "openstack_compute_instance_v2" "wordpress" {
  count             = var.wp_instances
  name              = "wordpress_${count.index + 1}"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = data.openstack_compute_keypair_v2.default_keypair.id

  network {
    port = openstack_networking_port_v2.wp_ports[count.index].id
  }

  depends_on = [
    openstack_networking_router_interface_v2.router_interface,
    openstack_lb_pool_v2.pool
  ]
}
