data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  #   values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["amazon"] 
}

data "aws_security_group" "web-sg" {
  filter {
    name   = "tag:Name"
    values = [var.web-sg-name]
  }
}

data "aws_security_group" "app-sg" {
  filter {
    name   = "tag:Name"
    values = [var.app-sg-name]
  }
}

data "aws_subnet" "public-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.public-subnet1]
  }
}

data "aws_subnet" "public-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.public-subnet2]
  }
}

data "aws_subnet" "web-private-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.web-private-subnet1]
  }
}

data "aws_subnet" "web-private-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.web-private-subnet2]
  }
}

data "aws_subnet" "app-private-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.app-private-subnet1]
  }
}

data "aws_subnet" "app-private-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.app-private-subnet2]
  }
}

data "aws_lb_target_group" "web-tg" {
  tags = {
    Name = var.web-tg-name
  }
}

data "aws_lb_target_group" "app-tg" {
  tags = {
    Name = var.app-tg-name
  }
}

data "aws_iam_instance_profile" "instance-profile" {
  name = var.instance-profile-name
}