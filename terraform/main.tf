module "vm1" {
  source = "./modules/compute"

  name    = "Super"
  port_id = module.port.id
  keypair = var.keypair

}

module "network" {
  source = "./modules/network"

  name = "network_1"
}

module "subnet" {
  source = "./modules/network/subnet"

  name       = "subnet_1"
  network_id = module.network.id
  cidr       = var.cidr
}

module "port" {
  source = "./modules/network/port"

  name         = "port"
  network_id   = module.network.id
  subnet_id    = module.subnet.id
  secgroup_ids = [module.ssh_secgroup.id]
}

module "router" {
  source = "./modules/network/router"

  name = "public_router"
}

module "router_interface" {
  source = "./modules/network/router_interface"

  router_id = module.router.id
  subnet_id = module.subnet.id

}

module "floating_ip" {
  source = "./modules/network/floating_ip"

  port_id = module.port.id
}

module "ssh_secgroup" {
  source = "./modules/network/security_group"

  name      = "ssh"
  direction = "ingress"
  port_min  = 22
  port_max  = 22
}
