provider "aws" {
  region = var.aws_region
}


module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
  vpc_name    = var.vpc_name
}

module "sg" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source    = "./modules/ec2"
  subnet_id = module.vpc.subnet_id
  sg_id     = module.sg.sg_id
  key_name  = var.key_name
  ami_id    = var.ami_id
}
