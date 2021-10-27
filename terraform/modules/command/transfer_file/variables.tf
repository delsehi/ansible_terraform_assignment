variable "source_file" {
  type = string
}
variable "destination_file" {
  type = string
}
variable "remote_host" {
  type = string
}
variable "connection_type" {
  default = "ssh"
}
variable "user" {
  default = "ubuntu"
}
variable "private_key" {
  type = string
}
