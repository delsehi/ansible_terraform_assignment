variable "command" {
  type = string
}
variable "remote_host" {
  type = string
}
variable "connection_type" {
  type    = string
  default = "ssh"
}
variable "user" {
  type    = string
  default = "ubuntu"
}
variable "private_key" {
  type = string
}
