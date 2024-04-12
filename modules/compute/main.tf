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