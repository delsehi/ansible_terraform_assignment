variable "name" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "secgroup_ids" {
  type = list(any)
}
