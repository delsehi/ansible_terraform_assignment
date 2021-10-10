# Create database master node
resource "openstack_compute_instance_v2" "db_master" {
  name              = "db_master"
  image_name        = "Ubuntu server 20.04"
  flavor_name       = "c1-r2-d5"
  availability_zone = "Education"
  key_pair          = var.keypair
  security_groups   = ["default", "${openstack_compute_secgroup_v2.ssh_secgroup.id}"]
  
  network {
    name = "network_1"
  }
}
