# Create control node instance
module "control_node" {
  source = "./modules/compute"

  name    = "control_node"
  port_id = module.control_node_port.id
  keypair = var.keypair
}


# Create wordpress instances
module "wordpress" {
  source = "./modules/compute"

  count   = var.wp_instances
  name    = "wordpress_${count.index + 1}"
  port_id = module.wordpress_port[count.index].id
  keypair = var.keypair

}

module "database" {
  source = "./modules/compute"

  count   = 2
  name    = "db_${count.index + 1}"
  port_id = module.database_port[count.index].id
  keypair = var.keypair
}

module "fileserver" {
  source = "./modules/compute"

  name    = "fileserver"
  port_id = module.fileserver_port.id
  keypair = var.keypair
}
