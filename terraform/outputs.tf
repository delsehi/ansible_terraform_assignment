output "wordpress" {
  value = module.wordpress[*].internal_ip
}

output "loadbalancer_ip" {
  value = module.loadbalancer_floating_ip.address
}
