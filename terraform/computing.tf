# Create wordpress instances
module "wordpress" {
  source = "./modules/compute"

  count   = var.wp_instances
  name    = "wordpress_${count.index + 1}"
  port_id = module.port[count.index].id
  keypair = var.keypair

}
