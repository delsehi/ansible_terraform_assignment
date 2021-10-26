variable "name" {
  type = string
}

variable "direction" {
  type = string
}

variable "protocol" {
  type    = string
  default = "tcp"
}

variable "port_min" {
  type = number
}

variable "port_max" {
  type = number
}

variable "remote_ip_prefix" {
  type    = string
  default = "0.0.0.0/0"
}
