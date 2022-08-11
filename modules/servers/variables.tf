variable "env_name" {
    type        = string
    description = "An environment name"
}

variable "vpc_id" {
    type        = string
    description = "VPC id"
}

variable "ami" {
    type = string
    description = "AMI id"
}

variable "pub_subnet_1" {
    type        = string
    description = "public subnet 1"
}

variable "pub_subnet_2" {
    type        = string
    description = "public subnet 2"
}

variable "prv_subnet_1" {
    type        = string
    description = "private subnet 1"
}

variable "prv_subnet_2" {
    type        = string
    description = "private subnet 2"
}