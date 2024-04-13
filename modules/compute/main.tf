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
  subnet_id       = var.private_server_id
  security_groups = [ var.private_server_sg ]
  iam_instance_profile = aws_iam_instance_profile.modify_role.name
  tags = {
    "Name" = "EC2 Private"
  }
}
# Create IAM Role for EC2 instance to have full access to S3
resource "aws_iam_role" "full_access_s3" {
  name = "EC2fullaccessS3"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  # We use the policy name: AmazonS3FullAccess to grant permission for EC2 instance to have full access to S3
  assume_role_policy = jsondecode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
  })
}
# Provides an IAM instance profile.
resource "aws_iam_instance_profile" "modify_role" {
  # Optional: Name of the role to add to the profile
  role = aws_iam_role.full_access_s3.name
}
