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
  availability_zone         = var.availability_zones[0]
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
  availability_zone         = var.availability_zones[1]
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
  availability_zone         = var.availability_zones[0]
  cidr_block                = "10.10.3.0/24"
  map_public_ip_on_launch   = false
  tags = {
    "Name" = "Private Subnet 1"
  }
}

## Create Private Subnet 2
resource "aws_subnet" "two_tier_private_subnet_2" {
  vpc_id                    = aws_vpc.two_tier.id
  availability_zone         = var.availability_zones[1]
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

# Create a route table for public subnet
resource "aws_route_table" "two_tier_rt_public" {
  vpc_id = aws_vpc.two_tier.id
  tags = {
    "Name" = "Route Table Public"
  }
}

resource "aws_route" "two_tier_rt_public" {
  route_table_id            = aws_route_table.two_tier_rt_public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.two_tier_igw.id
}
# Associate route table with public subnet 1
resource "aws_route_table_association" "two_tier_rt_public" {
  # Required: The ID of the routing table to associate with.
  route_table_id  = aws_route_table.two_tier_rt_public.id
  # Optional: The subnet ID to create an association.
  subnet_id       = aws_subnet.two_tier_public_subnet_1.id
}
# Associate route table with public subnet 2
resource "aws_route_table_association" "two_tier_rt_public" {
  # Required The ID of the routing table to associate with.
  route_table_id  = aws_route_table.two_tier_rt_public.id
  # Optional The subnet ID to create an association.
  subnet_id       = aws_subnet.two_tier_public_subnet_2.id
}