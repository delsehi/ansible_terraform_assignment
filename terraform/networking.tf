# Create network
module "network" {
  source = "./modules/network"

  name = "network_1"
}

# Create subnet
module "subnet" {
  source = "./modules/network/subnet"

  name       = "subnet_1"
  network_id = module.network.id
  cidr       = var.cidr
}

# Create ports
module "port" {
  source = "./modules/network/port"

  count        = var.wp_instances
  name         = "port_${count.index + 1}"
  network_id   = module.network.id
  subnet_id    = module.subnet.id
  secgroup_ids = [module.ssh_secgroup.id]
}

# Create router
module "router" {
  source = "./modules/network/router"

  name = "public_router"
}

# Create router interface
module "router_interface" {
  source = "./modules/network/router_interface"

  router_id = module.router.id
  subnet_id = module.subnet.id

}

# Create loadbalancer floating ip
module "loadbalancer_floating_ip" {
  source  = "./modules/network/floating_ip"
  port_id = module.loadbalancer.port_id
}

# Create ssh security group
module "ssh_secgroup" {
  source = "./modules/network/security_group"

  name      = "ssh"
  direction = "ingress"
  port_min  = 22
  port_max  = 22
}
