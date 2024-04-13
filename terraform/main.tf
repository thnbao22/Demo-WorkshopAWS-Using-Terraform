provider "aws" {
  region = "ap-southeast-1"
  # Access the AWS Management Console and create an access/ secret key and enter it below
#  access_key = s
#  secret_key = 
}

locals {
  instance_type = "t2.micro"
  # use the Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume type
  ami           = "ami-0fd77db8c27ba5cc5"
}

module "storage" {
  source = "../modules/storage"
}
module "networking" {
  source = "../modules/networking"
}
module "compute" {
  source = "../modules/compute"
  ami = local.ami
  instance_type = local.instance_type
  # We launch our Bastion Host on Public Subnet 2
  bastion_subnet_id = module.networking.public_subnets_2_id
  # We launch out EC2 Private on Private Subnet 1
  private_subnet_id = module.networking.private_subnets_1_id
  # SG for Public Subnet
  bastion_sg = module.networking.public_subnet_sg_id
  # SG fro Private Subnet
  private_server_sg = module.networking.private_subnet_sg_id
}
