# The ID of the VPC
output "vpc_id" {
  value = aws_vpc.two_tier.id
}
# the ID of Public Subnets 1
output "public_subnets_1_id" {
  value = aws_subnet.two_tier_private_subnet_1.id
}
# the ID of Public Subnets 2
output "public_subnets_2_id" {
  value = aws_subnet.two_tier_private_subnet_2.id
}
# The ID of Private Subnets 1
output "private_subnets_1_id" {
  value = aws_subnet.two_tier_private_subnet_1.id
}
# The ID of Private Subnets 2
output "private_subnets_2_id" {
  value = aws_subnet.two_tier_private_subnet_2.id
}