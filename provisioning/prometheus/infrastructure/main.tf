# Create an EC2 instance

# Provider
provider "aws" {

  # Which region we use
  region = "eu-west-1"
}


# CONTROLLER NODE


# Security group
resource "aws_security_group" "prometheus_sg" {
    name = var.sg_name
  # Tags
  tags = {
    Name = var.sg_name

  }

}

# NSG Rules
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_22" {

  security_group_id = aws_security_group.prometheus_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  cidr_ipv4         = var.vpc_ssh_inbound_cidr
  tags = {
    Name = "Allow_SSH"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_9090" {

  security_group_id = aws_security_group.prometheus_sg.id
  from_port         = 9090
  ip_protocol       = "tcp"
  to_port           = 9090
  cidr_ipv4         = var.vpc_ssh_inbound_cidr
  tags = {
    Name = "Allow_9000"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_out_all" {

  security_group_id = aws_security_group.prometheus_sg.id
  ip_protocol       = "All"
  cidr_ipv4         = var.vpc_ssh_inbound_cidr
  tags = {
    Name = "Allow_Out_all"
  }
}

resource "aws_ec2_instance_state" "prometheus_instance_state" {
  instance_id = aws_instance.prometheus_instance.id
  state       = "running"
}

# Resource to create
resource "aws_instance" "prometheus_instance" {
   
  # AMI ID ami-0c1c30571d2dae5c9 (for ubuntu 22.04 lts)
  ami = var.app_ami_id

  instance_type = var.instance_type

  # Public ip
  associate_public_ip_address = var.associate_pub_ip

  # Security group
  vpc_security_group_ids = [aws_security_group.prometheus_sg.id]

  # SSH Key pair
  key_name = var.ssh_key_name

    # user_data="${file("../prometheus-prov.sh")}"
  
  # Name the resource
  tags = {
    Name = var.instance_name
  }

}


