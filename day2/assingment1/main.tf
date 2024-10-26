provider "aws" {
  region = "us-east-1"
}


module "vpc_w_subnets" {
  source = "./modules/vpc"
  Name   = "aslam-vpc"
}

module "asg_alb" {
  source  = "./modules/asg_alb"
  vpc_id  = module.vpc_w_subnets.vpc_id
  subnets = module.vpc_w_subnets.public_subnets
}

module "rds" {
  source       = "./modules/rds"
  vpc_id       = module.vpc_w_subnets.vpc_id
  server_sg_id = module.asg_alb.server_sg_id
  db_subnets   = module.vpc_w_subnets.private_subnets
}

output "dns" {
  value = module.asg_alb.dns_name
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
