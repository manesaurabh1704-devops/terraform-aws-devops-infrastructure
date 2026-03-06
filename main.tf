module "vpc" {

  source = "./modules/vpc"

}

module "subnet" {

  source = "./modules/subnet"

  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id

}

module "security_group" {

  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id

}

module "alb" {

  source = "./modules/alb"

  vpc_id = module.vpc.vpc_id

  public_subnet   = module.subnet.public_subnet
  public_subnet_2 = module.subnet.public_subnet_2

  sg_id = module.security_group.sg_id

}

module "autoscaling" {

  source = "./modules/autoscaling"

  ami_id = "ami-0b6c6ebed2801a5cb"

  instance_type = "t3.micro"

  sg_id = module.security_group.sg_id

  private_subnet = module.subnet.private_subnet

  target_group_arn = module.alb.target_group_arn

}
