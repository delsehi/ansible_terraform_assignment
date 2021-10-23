output "name" {
  value = openstack_compute_instance_v2.compute.name
}

output "internal_ip" {
  value = openstack_compute_instance_v2.compute.access_ip_v4
}
