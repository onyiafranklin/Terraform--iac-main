output "VPC" {
    value       = aws_vpc.vpc.id
    description = "A reference to the created VPC"
}
output "PublicSubnet1" {
    value       = aws_subnet.PublicSubnet1.id
    description = "Public subnet 1 id"
}

output "PublicSubnet2" {
    value       = aws_subnet.PublicSubnet2.id
    description = "Public subnet 2 id"
}

output "PrivateSubnet1" {
    value       = aws_subnet.PrivateSubnet1.id
    description = "Private subnet 1 id"
}

output "PrivateSubnet2" {
    value       = aws_subnet.PrivateSubnet2.id
    description = "Private subnet 2 id"
}

output "AZ1" {
    value       = var.az1
    description = "Availability zone 1"
}

output "AZ2" {
    value       = var.az2
    description = "Availability zone 2"
}