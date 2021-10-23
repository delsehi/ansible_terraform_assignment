# output "ports" {
#   value = {
#     "control_node_port" : openstack_networking_port_v2.control_node_port,
#     "wordpress_ports" : openstack_networking_port_v2.wp_ports,
#     "database_ports" : openstack_networking_port_v2.db_ports,
#     "fileserver_port" : openstack_networking_port_v2.file_server_port
#   }
# }

output "network_1" {
  value = openstack_networking_network_v2.network_1
}

output "subnet_1" {
  value = openstack_networking_subnet_v2.subnet_1
}

output "ssh_secgroup" {
  value = openstack_networking_secgroup_v2.ssh_secgroup
}

output "http_secgroup" {
  value = openstack_networking_secgroup_v2.http_secgroup
}

# output "loadbalancer_floating_ip" {
#   value = openstack_networking_floatingip_v2.loadbalancer_fip
# }

output "control_node_floating_ip" {
  value = openstack_networking_floatingip_v2.control_node_fip
}

output "router_interface" {
  value = openstack_networking_router_interface_v2.router_interface
}
