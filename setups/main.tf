provider "aws" {
    region = "us-east-1"
}

module network_architecture {
  source            = "../modules/networks"
  env_name          = "udapeople-terraform"
  vpc_cidr_block    = "10.0.0.0/16"
}
