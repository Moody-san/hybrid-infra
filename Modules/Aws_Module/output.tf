output "server_public_ip" {
  value = aws_eip.one.public_ip
}
output "vpc_id" {
  value = aws_vpc.vpc_a.id
}