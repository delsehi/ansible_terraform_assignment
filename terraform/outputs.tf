output "wordpress_instances" {
  value = length(module.wordpress[*])
}

output "loadbalancer_ip" {
  value = module.loadbalancer_floating_ip.address
}

output "control_node_ip" {
  value = module.control_node_floating_ip.address
}
