module "vm1" {
  source = "./modules/compute"

  name    = "vm1"
  port_id = module.port.id

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

  name       = "port"
  network_id = module.network.id
  subnet_id  = module.subnet.id

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
