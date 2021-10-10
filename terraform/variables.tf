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
variable "private_key" {
  type = string # Path to your private ssh key for cscloud, this will be added to the control_node
}
variable "public_key" {
  type = string # Path to your public ssh key for cscloud, this will be added to the control_node
}