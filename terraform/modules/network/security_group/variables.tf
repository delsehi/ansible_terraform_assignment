variable "name" {

}

variable "direction" {

}

variable "protocol" {
  type    = string
  default = "tcp"
}

variable "port_min" {

}

variable "port_max" {

}

variable "remote_ip_prefix" {
  type    = string
  default = "0.0.0.0/0"
}
