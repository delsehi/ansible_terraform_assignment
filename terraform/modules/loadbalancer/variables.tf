variable "name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "secgroup_ids" {
  type = list(any)
}

variable "members" {
  type = list(any)
}
