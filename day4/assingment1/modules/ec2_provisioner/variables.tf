

variable "instance_count" {
  default = 1
  type    = number
}

variable "security_group_ids" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "inline_remote_commands" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "rds_endpoint" {
  type = string
}
