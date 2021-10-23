output "wordpress" {
  value = openstack_compute_instance_v2.wordpress
}

output "db_master" {
  value = openstack_compute_instance_v2.db_master
}

output "db_slave" {
  value = openstack_compute_instance_v2.db_slave
}

output "file_server" {
  value = openstack_compute_instance_v2.file_server
}
