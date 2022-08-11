variable "env_name" {
    type        = string
    description = "Environment variable name"
}

variable "vpc_cidr_block" {
    type        = string
    description = "vpc cidr block"
}
variable "az1" {
    type        = string
    description = "This is availability zone  1"
}
variable "az2" {
    type        = string
    description = "This is availability zone  2"
}
variable "public_subnet1_cidr_block" {
    type        = string
    description = "This is cidr for public subnet 1"
}
variable "public_subnet2_cidr_block" {
    type        = string
    description = "This is cidr for public subnet 2"
}
variable "private_subnet1_cidr_block" {
    type        = string
    description = "This is cidr for public subnet 1"
}
variable "private_subnet2_cidr_block" {
    type        = string
    description = "This is cidr for public subnet 2"
}