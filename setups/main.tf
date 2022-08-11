provider "aws" {
    region = "us-east-1"
}

module network_architecture {
  source                           = "../modules/networks"
  env_name                         = "udapeople-terraform"
  vpc_cidr_block                   = "10.0.0.0/16"
  az1                              = "us-east-1a"
  az2                              = "us-east-1b"
  public_subnet1_cidr_block        = "10.0.0.0/24"
  public_subnet2_cidr_block        = "10.0.1.0/24"
  private_subnet1_cidr_block       = "10.0.2.0/24"
  private_subnet2_cidr_block       = "10.0.3.0/24"
  
}
module servers {
  source                           = "../modules/servers"
  env_name                         = "udapeople-terraform"
  vpc_id                           = module.network_architecture.VPC
  ami                              = "ami-052efd3df9dad4825"
  pub_subnet_1                     = module.network_architecture.PublicSubnet1
  pub_subnet_2                     = module.network_architecture.PublicSubnet2
  prv_subnet_1                     = module.network_architecture.PrivateSubnet1
  prv_subnet_2                     = module.network_architecture.PrivateSubnet2
}

output "VPC" {
  value = module.network_architecture.VPC
}
output "Publicsubnet1" {
  value = module.network_architecture.PublicSubnet1
}

output "Publicsubnet2" {
  value = module.network_architecture.PublicSubnet2
}

output "Privatesubnet1" {
  value = module.network_architecture.PrivateSubnet1
}

output "Privatesubnet2" {
  value = module.network_architecture.PrivateSubnet2
}
