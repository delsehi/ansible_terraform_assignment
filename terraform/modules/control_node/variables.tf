variable "keypair" {}
# variable "ports" {}
variable "network" {}
variable "router_interface" {}
variable "private_key" {}
variable "public_key" {}
variable "git_access_token" {}
variable "git_api_url" {}
variable "db_master" {}
variable "db_slave" {}
variable "file_server" {}
variable "wordpress" {}
variable "ssh_secgroup" {}


# Declare variables needed to install and configure Ansible on control node
locals {
  install_ansible = {
    private_key    = file(var.private_key),
    public_key     = file(var.public_key),
    master_db_ip   = var.db_master.network[0].fixed_ip_v4,
    slave_db_ip    = var.db_slave.network[0].fixed_ip_v4,
    file_server_ip = var.file_server.network[0].fixed_ip_v4
    wp_nodes       = var.wordpress,
    access_token   = var.git_access_token,
    api_url        = var.git_api_url,
  }
}

# locals {
#   install_ansible = {
#     private_key    = file(var.private_key),
#     public_key     = file(var.public_key),
#     master_db_ip   = openstack_compute_instance_v2.db_master.network[0].fixed_ip_v4,
#     slave_db_ip    = openstack_compute_instance_v2.db_slave.network[0].fixed_ip_v4,
#     file_server_ip = openstack_compute_instance_v2.file_server.network[0].fixed_ip_v4
#     wp_nodes       = openstack_compute_instance_v2.wordpress,
#     access_token   = var.git_access_token,
#     api_url        = var.git_api_url,
#   }
# }
