# Create wordpress server instances
resource "openstack_compute_instance_v2" "wordpress" {
  count             = var.wp_instances
  name              = "wordpress_${count.index + 1}"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  security_groups   = ["default", openstack_networking_secgroup_v2.ssh_secgroup.id, openstack_networking_secgroup_v2.http_secgroup.id]
  key_pair          = var.keypair

  network {
    port = openstack_networking_port_v2.wp_ports[count.index].id
  }
}