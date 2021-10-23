# #################################################################
# # Ports are created and connects compute instances to the network.
# # The security groups to be used are also added to the ports.
# ##################################################################

# # Create port for the control node
# resource "openstack_networking_port_v2" "control_node_port" {
#   name       = "control_node_port"
#   network_id = openstack_networking_network_v2.network_1.id

#   fixed_ip {
#     subnet_id = openstack_networking_subnet_v2.subnet_1.id
#   }

#   security_group_ids = [
#     openstack_networking_secgroup_v2.ssh_secgroup.id,
#     data.openstack_networking_secgroup_v2.default_secgroup.id
#   ]
# }

# # Create port for the file server
# resource "openstack_networking_port_v2" "file_server_port" {
#   name       = "file_server_port"
#   network_id = openstack_networking_network_v2.network_1.id

#   fixed_ip {
#     subnet_id = openstack_networking_subnet_v2.subnet_1.id
#   }

#   security_group_ids = [
#     openstack_networking_secgroup_v2.ssh_secgroup.id,
#     data.openstack_networking_secgroup_v2.default_secgroup.id
#   ]
# }

# # Create ports for wordpress instances
# resource "openstack_networking_port_v2" "wp_ports" {
#   count      = var.wp_instances
#   name       = "wp_${count.index + 1}_port"
#   network_id = openstack_networking_network_v2.network_1.id

#   fixed_ip {
#     subnet_id = openstack_networking_subnet_v2.subnet_1.id
#   }
#   security_group_ids = [
#     openstack_networking_secgroup_v2.ssh_secgroup.id,
#     openstack_networking_secgroup_v2.http_secgroup.id,
#     data.openstack_networking_secgroup_v2.default_secgroup.id
#   ]
# }

# # Create ports for the databases
# resource "openstack_networking_port_v2" "db_ports" {
#   count      = 2
#   name       = "db_${count.index + 1}_port"
#   network_id = openstack_networking_network_v2.network_1.id

#   fixed_ip {
#     subnet_id = openstack_networking_subnet_v2.subnet_1.id
#   }

#   security_group_ids = [
#     openstack_networking_secgroup_v2.ssh_secgroup.id,
#     data.openstack_networking_secgroup_v2.default_secgroup.id,
#     openstack_networking_secgroup_v2.db_secgroup.id
#   ]
# }
