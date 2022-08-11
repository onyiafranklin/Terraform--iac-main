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
