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
# the ID of route table public
output "route_table_public_id" {
  value = aws_route.two_tier_rt_public.id
}
# the ID of route table private
output "route_table_private_id" {
  value = aws_route.two_tier_rt_private.id
}
# the ID of Public Subnet SG
output "public_subnet_sg_id" {
  value = aws_security_group.two_tier_public_sg.id
}
# the ID of Private Subnet SG
output "private_subnet_sg_id" {
  value = aws_security_group.two_tier_private_sg.id
}