# The ID of the VPC
output "vpc_id" {
  value = aws_vpc.two_tier.id
}