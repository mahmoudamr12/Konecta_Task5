output "vpc_id" {
  value = aws_vpc.arch1_vpc.id
}

output "nat_gateway_ip" {
  value = aws_eip.nat_eip.public_ip
}
