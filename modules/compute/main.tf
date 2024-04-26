# We will launch 2 EC2 instances, one in public subnet and the other in private subnet
# in the workshop, you can already see that we use EC2 instance in public subnet to ssh into EC2 instance in Private Subnet
# Thus, we can consider the EC2 instance in the public subnet as a Bastion Host
# Ctrate EC2 server in Public Subnet
resource "aws_instance" "Bastion_Host" {
  # Optional: AMI to use for the instance.  
  ami               = var.ami
  # Optional: Instance type to use for the instance
  instance_type     = var.instance_type
  # Create a keypair on AWS Management Console and include it right here
  # I just name it demo-workshop. You can modify the attribute based on your keypair's name
  key_name          = "demo-workshop"
  # Optional: VPC Subnet ID to launch in.   
  subnet_id         = var.bastion_subnet_id
  # We launch this bastion Host on public subnet so we will add the attribute secuirty group 
  security_groups   = [ var.bastion_sg ]
  tags = {
    "Name" = "EC2 Public"
  }
}
# Create EC2 server in Private Subnet
resource "aws_instance" "private_server" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = "demo-workshop"
  subnet_id       = var.private_subnet_id
  security_groups = [ var.private_server_sg ]
  # Optional: IAM Instance Profile to launch the instance with. 
  # Specified as the name of the Instance Profile.
  iam_instance_profile = aws_iam_instance_profile.EC2-profile.name
  tags = {
    "Name" = "EC2 Private"
  }
}

# Create an IAM role
resource "aws_iam_policy" "S3-Full-Access" {
  name = "S3-Full-Access-Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "s3-object-lambda:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create an IAM role
resource "aws_iam_role" "full-access-s3" {
  name = "EC2-full-Access-S3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the Policy to the created IAM role
resource "aws_iam_policy_attachment" "attach-policy" {
  name        = "test-attach"
  roles       = [ aws_iam_role.full-access-s3.name]
  policy_arn  = aws_iam_policy.S3-Full-Access.arn    
}

# Create an IAM instance profile  
resource "aws_iam_instance_profile" "EC2-profile" {
  name = "demo_profile"
  role = aws_iam_role.full-access-s3.name
}
