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

# Create Subnets
# So we have 4 subnets which is 2 public subnets and 2 private subnets

## Create Public Subnet 1 
resource "aws_subnet" "two_tier_public_subnet_1" {
  # (Required) The VPC ID.
  vpc_id                    = aws_vpc.two_tier.id
  # (Optional) AZ for the subnet.
  availability_zone         = "ap-southeast-1a"
  # The IPv4 CIDR block for the subnet.
  cidr_block                = "10.10.1.0/24"
  map_public_ip_on_launch   = true
  tags = {
    "Name" = "Public Subnet 1"
  }
}

## Create Public Subnet 2 
resource "aws_subnet" "two_tier_public_subnet_2" {
  # (Required) The VPC ID.
  vpc_id                    = aws_vpc.two_tier.id
  # (Optional) AZ for the subnet.
  availability_zone         = "ap-southeast-1b"
  # The IPv4 CIDR block for the subnet.
  cidr_block                = "10.10.2.0/24"
  map_public_ip_on_launch   = true
  tags = {
    "Name" = "Public Subnet 2"
  }
}

## Create Private Subnet 1
### map_public_ip_on_launch is false means that the subnet is Private 
resource "aws_subnet" "two_tier_private_subnet_1" {
  vpc_id                    = aws_vpc.two_tier.id
  availability_zone         = "ap-southeast-1a"
  cidr_block                = "10.10.3.0/24"
  map_public_ip_on_launch   = false
  tags = {
    "Name" = "Private Subnet 1"
  }
}

## Create Private Subnet 2
resource "aws_subnet" "two_tier_private_subnet_2" {
  vpc_id                    = aws_vpc.two_tier.id
  availability_zone         = "ap-southeast-1b"
  cidr_block                = "10.10.4.0/24"
  map_public_ip_on_launch   = false
  tags = {
    "Name" = "Private Subnet 2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "two_tier_igw" {
  vpc_id = aws_vpc.two_tier.id
  tags = {
    "Name" = "Internet Gateway"
  }
}

# Create a NAT Gateway

## Before we can create a NAT Gateway, we need to allocate an Elastic IP address.
resource "aws_eip" "two_tier_nat" {
  domain = "vpc"
}
# Provides a resource to create a VPC NAT Gateway.
resource "aws_nat_gateway" "two_tier_nat" {
  allocation_id     = aws_eip.two_tier_nat.id
  subnet_id         = aws_subnet.two_tier_public_subnet_1.id
  tags = {
    "Name" = "NAT Gateway"
  }
}
