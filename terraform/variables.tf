# Set variables in terraform.tfvars.
# Make sure that the public key is formated to a single line, also copy your private key and indent all rows below the first one with 4 spaces.

# Private key format example with indented rows below the first one:
# -----BEGIN RSA PRIVATE KEY-----
#    AkbAtkAJWBEAajbetkabetkBAkhbtalhbetlahebtlabeltaheblahbeljhtbalj
#    alwetgl1327iuawhrku12ir7192rkasbfghbqek13our13or7t1o3grl1gljhgaj
#    ...
#    -----END RSA PRIVATE KEY-----

variable "keypair" {
  type = string # The name of your keypair in cscloud
}
variable "wp_instances" {
  type = number # The number of wordpress server instances you want to create
}
variable "cidr" {
  type = string
}
variable "private_key" {
  type = string # Path to your private ssh key for cscloud, this will be added to the control_node
}
variable "private_key_formatted" {
  type = string
}
variable "public_key" {
  type = string # Path to your public ssh key for cscloud, this will be added to the control_node
}
variable "git_access_token" {
  type = string # Access token to ansible playbooks
}
variable "git_api_url" {
  type = string # Url to gitlab api endpoint to download repo
}

locals {
  install_ansible = {
    private_key    = file(var.private_key_formatted),
    public_key     = file(var.public_key),
    master_db_ip   = module.database[0].internal_ip,
    slave_db_ip    = module.database[1].internal_ip,
    file_server_ip = module.fileserver.internal_ip,
    wp_nodes       = module.wordpress,
    access_token   = var.git_access_token,
    api_url        = var.git_api_url,
  }
}
