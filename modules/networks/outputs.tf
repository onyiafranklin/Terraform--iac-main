output "VPC" {
    value       = aws_vpc.vpc.id
    description = "A reference to the created VPC"
}