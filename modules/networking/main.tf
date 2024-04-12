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
# 0.0.0.0/0 represents internet
resource "aws_route" "two_tier_rt_public" {
  route_table_id            = aws_route_table.two_tier_rt_public.id
  destination_cidr_block    = "0.0.0.0/0"
  # Resources within the public subnet can access the internet through the Internet Gateway.
  gateway_id                = aws_internet_gateway.two_tier_igw.id
}
# Associate route table with public subnet 1
resource "aws_route_table_association" "two_tier_rt_public_associate" {
  # Required: The ID of the routing table to associate with.
  route_table_id  = aws_route_table.two_tier_rt_public.id
  # Optional: The subnet ID to create an association.
  subnet_id       = aws_subnet.two_tier_public_subnet_1.id
}
# Associate route table with public subnet 2
resource "aws_route_table_association" "two_tier_rt_public_associate" {
  # Required The ID of the routing table to associate with.
  route_table_id  = aws_route_table.two_tier_rt_public.id
  # Optional The subnet ID to create an association.
  subnet_id       = aws_subnet.two_tier_public_subnet_2.id
}
# Create a route table for private subnet
resource "aws_route_table" "two_tier_rt_private" {
  vpc_id = aws_vpc.two_tier.id
  tags = {
    "Name" = "Route Table Private"
  }
}

resource "aws_route" "two_tier_rt_private" {
  route_table_id            = aws_route_table.two_tier_rt_private.id
  destination_cidr_block    = "0.0.0.0/0"
  # Resources within the private subnet can access the internet through the NAT Gateway.
  gateway_id                = aws_nat_gateway.two_tier_nat.id
}
# Associate route table with private subnet 1
resource "aws_route_table_association" "two_tier_rt_private_associate" {
  # Required: The ID of the routing table to associate with.
  route_table_id  = aws_route_table.two_tier_rt_private.id
  # Optional: The subnet ID to create an association.
  subnet_id       = aws_subnet.two_tier_private_subnet_1.id
}
# Associate route table with privatet subnet 2
resource "aws_route_table_association" "two_tier_rt_private_associate" {
  # Required The ID of the routing table to associate with.
  route_table_id  = aws_route_table.two_tier_rt_public.id
  # Optional The subnet ID to create an association.
  subnet_id       = aws_subnet.two_tier_private_subnet_2.id
}

# This data source would help you retrieve your Local IP 
# When you click on https://ipv4.icanhazip.com, a black screen will display your local IP.
# Link I found on Stackoverflow, you can click on it below.
# Link: https://stackoverflow.com/questions/46763287/i-want-to-identify-the-public-ip-of-the-terraform-execution-environment-and-add 
data "http" "local_ip" {
  url = "https://ipv4.icanhazip.com"
}

# Create Security Group   
## Security Group for a server in a Public Subnet
resource "aws_security_group" "two_tier_public_sg" {
  name        = "Public Subnet SG"
  description = "Allow SSH and Ping for servers in the public subnet"
  vpc_id      = aws_vpc.two_tier.id
  ingress {
    # define inbound rules allow SSH from your local machines
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.local_ip.response_body)}/32"]
    # use chomp() method to remove any trailing space or new line which comes with body.
  }
  ingress {
    # You can read this blog to configure All-ICMP IPv4 rule.
    # link: https://blog.jwr.io/terraform/icmp/ping/security/groups/2018/02/02/terraform-icmp-rules.html
    # Allow ping from any IP address.
    from_port   = 8 #this strange syntax to allow ping
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  lifecycle {
    create_before_destroy = true
  }
}
## Security Group for a server in a Private Subnet
resource "aws_security_group" "two_tier_private_sg" {
  name        = "Private Subnet SG"
  description = "Allow SSH and Ping for servers in the private subnet"
  vpc_id      = aws_vpc.two_tier.id
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    # Here we choose the Public Subnet SG so that we can ssh into EC2 instance in Private Subnet via EC2 instance in Public Subnet
    # So we can call the EC2 instance in Public Subnet is Bastion Host
    security_groups = [ aws_security_group.two_tier_public_sg.id ]
  }
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  lifecycle {
    create_before_destroy = true
  }
}
# In this workshop, we choose Service Name: com.amazonaws.ap-southeast-1.s3 and Type: Gateway
resource "aws_vpc_endpoint" "gateway_endpoint_s3" {
  vpc_id            = aws_vpc.two_tier.id
  service_name      = "com.amazonaws.ap-southeast-1.s3"
  vpc_endpoint_type = "Gateway"
  # One or more route table IDs. Applicable for endpoints of type Gateway
  route_table_ids   = [ aws_route_table.two_tier_rt_private.id ]
  tags = {
    "key" = "workshop-endpoint"
  }
}