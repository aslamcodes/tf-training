variable "vpc_id" {
  type = string
}

variable "server_sg_id" {
  type = string
}

variable "db_subnets" {
  type = list(any)
}
