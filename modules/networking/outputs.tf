# The ID of the VPC
output "vpc_id" {
  value = aws_vpc.two_tier.id
}
# the ID of Public Subnets
output "public_subnets" {
  value = aws_subnet.two_tier_public_subnet.*.id
}
# The ID of Private Subnets
output "private_subnets" {
  value = aws_subnet.two_tier_private_subnet.*.id
}