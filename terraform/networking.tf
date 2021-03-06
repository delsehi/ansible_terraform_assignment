# Create network
module "network" {
  source = "./modules/network"

  name = "1"
  cidr = var.cidr
}

# Create control node port
module "control_node_port" {
  source = "./modules/network/port"

  name       = "control_node_port"
  network_id = module.network.network_id
  subnet_id  = module.network.subnet_id

  secgroup_ids = [
    module.ssh_secgroup.id
  ]
}

# Create wordpress ports
module "wordpress_port" {
  source = "./modules/network/port"

  count      = var.wp_instances
  name       = "port_${count.index + 1}"
  network_id = module.network.network_id
  subnet_id  = module.network.subnet_id

  secgroup_ids = [
    module.ssh_secgroup.id,
    module.http_secgroup.id
  ]
}

# Create database ports
module "database_port" {
  source = "./modules/network/port"

  count      = 2
  name       = "db_port_${count.index + 1}"
  network_id = module.network.network_id
  subnet_id  = module.network.subnet_id

  secgroup_ids = [
    module.ssh_secgroup.id,
    module.database_secgroup.id
  ]
}

# Create fileserver port
module "fileserver_port" {
  source = "./modules/network/port"

  name       = "fileserver_port"
  network_id = module.network.network_id
  subnet_id  = module.network.subnet_id

  secgroup_ids = [
    module.ssh_secgroup.id
  ]
}

# Create loadbalancer floating ip
module "loadbalancer_floating_ip" {
  source  = "./modules/network/floating_ip"
  port_id = module.loadbalancer.port_id

  depends_on = [
    module.loadbalancer
  ]
}

# Create control node floating ip
module "control_node_floating_ip" {
  source  = "./modules/network/floating_ip"
  port_id = module.control_node_port.id
}

# Create ssh security group
module "ssh_secgroup" {
  source = "./modules/network/security_group"

  name      = "ssh"
  direction = "ingress"
  port_min  = 22
  port_max  = 22
}

# Create http security group
module "http_secgroup" {
  source = "./modules/network/security_group"

  name      = "http"
  direction = "ingress"
  port_min  = 80
  port_max  = 80
}

# Create database security group
module "database_secgroup" {
  source = "./modules/network/security_group"

  name      = "http"
  direction = "ingress"
  port_min  = 3306
  port_max  = 3307
}
