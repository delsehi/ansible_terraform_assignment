module "loadbalancer" {
  source = "./modules/loadbalancer"

  name         = "loadbalancer"
  subnet_id    = module.network.subnet_id
  secgroup_ids = [module.ssh_secgroup.id]
  members      = module.wordpress[*].internal_ip
}

output "wordpress" {
  # count = var.wp_instances
  value = module.wordpress[*].internal_ip
}
