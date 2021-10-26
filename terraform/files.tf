# Transfer backup.sql file to control node
module "transfer_backupsql" {
  source = "./modules/file/transfer_file"

  source_file      = "./files/backup.sql"
  destination_file = "/home/ubuntu/backup.sql"
  remote_host      = module.control_node_floating_ip.address
  private_key      = file(var.private_key)

  depends_on = [
    module.control_node
  ]
}

# Transfer wordpress files to control node
module "transfer_wordpress_files" {
  source = "./modules/file/transfer_file"

  source_file      = "./files/acme_wordpress_files.tar.gz"
  destination_file = "/home/ubuntu/acme_wordpress_files.tar.gz"
  remote_host      = module.control_node_floating_ip.address
  private_key      = file(var.private_key)

  depends_on = [
    module.control_node
  ]
}

# Transfer xml import file to control node
module "transfer_xmlimport" {
  source = "./modules/file/transfer_file"

  source_file      = "./files/acme.wordpress.2018-10-09.xml"
  destination_file = "/home/ubuntu/acme.wordpress.2018-10-09.xml"
  remote_host      = module.control_node_floating_ip.address
  private_key      = file(var.private_key)

  depends_on = [
    module.control_node
  ]
}

# Create file containing loadbalancer ip on control node
module "create_loadbalancer_ip_file" {
  source = "./modules/file/remote_file"

  content          = module.loadbalancer_floating_ip.address
  destination_file = "/home/ubuntu/loadbalancer_ip.txt"
  remote_host      = module.control_node_floating_ip.address
  private_key      = file(var.private_key)

  depends_on = [
    module.control_node
  ]
}
