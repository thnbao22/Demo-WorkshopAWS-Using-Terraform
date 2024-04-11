# Create a VPC
resource "aws_vpc" "two_tier" {
  cidr_block            = "10.10.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true
  tags = {
    # Define name for your VPC
    "Name" = "CharlesVPC"
  }
}