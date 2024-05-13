data "aws_subnet" "db-private-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.db-private-subnet-name1]
  }
}

data "aws_subnet" "db-private-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.db-private-subnet-name2]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc-name]
  }
}

data "aws_security_group" "db-sg" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = [var.db-sg-name]
  }
}