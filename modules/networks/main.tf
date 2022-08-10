terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}
 resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  

  tags = {
    Name = "${var.env_name}-vpc"
  }
}