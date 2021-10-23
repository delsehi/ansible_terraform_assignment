module "network" {
  source = "./modules/network"

  # Dependencies
  loadbalancer = module.loadbalancer.loadbalancer
  control_node = module.control_node.control_node

  # Input variables
  wp_instances = var.wp_instances
  keypair      = var.keypair
  cidr         = var.cidr
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  wp_instances  = var.wp_instances
  wordpress     = module.application.wordpress
  subnet_1      = module.network.subnet_1
  ssh_secgroup  = module.network.ssh_secgroup
  http_secgroup = module.network.http_secgroup
  # loadbalancer_floating_ip = module.network.loadbalancer_floating_ip

}

module "control_node" {
  source = "./modules/control_node"

  # Dependencies
  # ports            = module.network.ports
  network          = module.network.network_1
  router_interface = module.network.router_interface
  ssh_secgroup     = module.network.ssh_secgroup

  # Input variables
  # wp_instances     = var.wp_instances
  keypair          = var.keypair
  private_key      = var.private_key
  public_key       = var.public_key
  git_access_token = var.git_access_token
  git_api_url      = var.git_api_url
  db_master        = module.application.db_master
  db_slave         = module.application.db_slave
  file_server      = module.application.file_server
  wordpress        = module.application.wordpress
}

module "application" {
  source = "./modules/application"

  # Dependencies
  # ports            = module.network.ports
  network          = module.network.network_1
  router_interface = module.network.router_interface
  ssh_secgroup     = module.network.ssh_secgroup
  http_secgroup    = module.network.http_secgroup

  # Input variables
  wp_instances = var.wp_instances
  keypair      = var.keypair
}

output "control_node_" {
  value = module.control_node.control_node.network
}
