output "vpc_id" {
  value       = aws_vpc.module_vpc.id
  description = "VPC ID"
}

output "vpc_cidr" {
  value       = aws_vpc.module_vpc.cidr_block
  description = "VPC CIDR Block"
}

output "public_subnet_cidr" {
  value = aws_subnet.public_subnet.cidr_block
}

output "private_subnet_cidr" {
  value = aws_subnet.private_subnet.cidr_block
}