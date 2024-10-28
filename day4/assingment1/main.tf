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

module "apache_server" {
  source             = "./modules/ec2_provisioner"
  instance_type      = "t2.medium"
  security_group_ids = [module.asg_alb.server_sg_id]
  inline_remote_commands = ["echo 'Hello from provisioner!' > /home/ubuntu/hello.txt"
  ]
  subnet_id    = module.vpc_w_subnets.public_subnets[0].id
  rds_endpoint = module.rds.rds_endpoint
}

output "dns" {
  value = module.asg_alb.dns_name
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "apache_ip" {
  value = module.apache_server.apache_server_ip
}
