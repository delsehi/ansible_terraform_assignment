# Run ansible playbook on control node
module "run_ansible" {
  source = "./modules/command/remote_exec"

  command     = "ansible-playbook 2dv*/ansible/playbook.yml"
  remote_host = module.control_node_floating_ip.address
  private_key = file(var.private_key)

  depends_on = [
    module.transfer_backupsql,
    module.transfer_wordpress_files,
    module.transfer_xmlimport,
    module.create_loadbalancer_ip_file
  ]
}

# Transfer backup.sql file to control node
module "transfer_backupsql" {
  source = "./modules/command/transfer_file"

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
  source = "./modules/command/transfer_file"

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
  source = "./modules/command/transfer_file"

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
  source = "./modules/command/remote_file"

  content          = module.loadbalancer_floating_ip.address
  destination_file = "/home/ubuntu/loadbalancer_fip.txt"
  remote_host      = module.control_node_floating_ip.address
  private_key      = file(var.private_key)

  depends_on = [
    module.control_node
  ]
}
