output "subnet_public_0" {
  value = aws_subnet.public-0.id
}

output "subnet_private_0" {
  value = aws_subnet.private-0.id
}

output "subnet_private_1" {
  value = aws_subnet.private-1.id
}

output "security_group_id" {
  value = aws_security_group.security-group.id
}
