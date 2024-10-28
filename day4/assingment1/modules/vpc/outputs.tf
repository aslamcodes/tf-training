
output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_arn" {
  value = aws_vpc.main.arn
}

output "public_subnets" {
  value = aws_subnet.subnet_public
}

output "private_subnets" {
  value = aws_subnet.subnet_private
}
