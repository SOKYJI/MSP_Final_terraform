# Creating VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = var.vpc-name
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw-name
  }

  depends_on = [aws_vpc.vpc]
}

###########################
#   Public
###########################

# Creating Public Subnet 1 for Web Tier Instance
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-cidr1
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = var.public-subnet1
  }

  depends_on = [aws_internet_gateway.igw]
}

# Creating Public Subnet 2 for Web Tier Instance
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-cidr2
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = var.public-subnet2
  }

  depends_on = [aws_subnet.public-subnet1]
}

###########################
#   WEB
###########################

# Creating WEB Private Subnet 1 for WEB Instance
resource "aws_subnet" "web-private-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web-private-cidr1
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = var.web-private-subnet1
  }

  depends_on = [aws_subnet.public-subnet2]
}

# Creating WEB Private Subnet 2 for WEB Instance
resource "aws_subnet" "web-private-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web-private-cidr2
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = var.web-private-subnet2
  }

  depends_on = [aws_subnet.web-private-subnet1]
}

###########################
#   APP
###########################

# Creating APP Private Subnet 1 for APP Instance
resource "aws_subnet" "app-private-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.app-private-cidr1
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = var.app-private-subnet1
  }

  depends_on = [aws_subnet.web-private-subnet2]
}

# Creating APP Private Subnet 2 for APP Instance
resource "aws_subnet" "app-private-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.app-private-cidr2
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = var.app-private-subnet2
  }

  depends_on = [aws_subnet.app-private-subnet1]
}

###########################
#   DB
###########################

# Creating DB Private Subnet 1 for RDS Instance
resource "aws_subnet" "db-private-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db-private-cidr1
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = var.db-private-subnet1
  }

  depends_on = [aws_subnet.app-private-subnet2]
}

# Creating DB Private Subnet 2 for RDS Instance
resource "aws_subnet" "db-private-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db-private-cidr2
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = var.db-private-subnet2
  }

  depends_on = [aws_subnet.db-private-subnet1]
}

###########################
#   NAT
###########################
# Creating Elastic IP for NAT Gateway 1
resource "aws_eip" "eip1" {
  domain = "vpc"

  tags = {
    Name = var.eip-name1
  }

  depends_on = [aws_subnet.db-private-subnet2]
}

# Creating Elastic IP for NAT Gateway 2
resource "aws_eip" "eip2" {
  domain = "vpc"

  tags = {
    Name = var.eip-name2
  }

  depends_on = [aws_eip.eip1]
}

# Creating NAT Gateway 1
resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public-subnet1.id

  tags = {
    Name = var.ngw-name1
  }

  depends_on = [aws_eip.eip2]
}

# Creating NAT Gateway 2
resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public-subnet2.id

  tags = {
    Name = var.ngw-name2
  }

  depends_on = [aws_nat_gateway.ngw1]
}

###########################
#   Route Table
###########################
# Creating Public Route table 1
resource "aws_route_table" "public-rt1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public-rt-name1
  }

  depends_on = [aws_nat_gateway.ngw2]
}

# Associating the Public Route table 1 Public Subnet 1
resource "aws_route_table_association" "public-rt-association1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rt1.id

  depends_on = [aws_route_table.public-rt1]
}

# Creating Public Route table 2 
resource "aws_route_table" "public-rt2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name       = var.public-rt-name2
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }

  depends_on = [aws_route_table_association.public-rt-association1]
}

# Associating the Public Route table 2 Public Subnet 2
resource "aws_route_table_association" "public-rt-association2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-rt2.id

  depends_on = [aws_route_table.public-rt2]
}


# Creating Private Route table 1
resource "aws_route_table" "private-rt1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw1.id
  }

  tags = {
    Name       = var.private-rt-name1
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }

  depends_on = [aws_route_table_association.public-rt-association2]
}

# Creating Private Route table 2 
resource "aws_route_table" "private-rt2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw2.id
  }

  tags = {
    Name       = var.private-rt-name2
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }

  depends_on = [aws_route_table.private-rt1]
}

# Associating the Private Route table 1 Web Private Subnet 1
resource "aws_route_table_association" "web-private-rt-association1" {
  subnet_id      = aws_subnet.web-private-subnet1.id
  route_table_id = aws_route_table.private-rt1.id

  depends_on = [aws_route_table.private-rt2]
}

# Associating the Private Route table 2 Web Private Subnet 2
resource "aws_route_table_association" "web-private-rt-association2" {
  subnet_id      = aws_subnet.web-private-subnet2.id
  route_table_id = aws_route_table.private-rt2.id

  depends_on = [aws_route_table_association.web-private-rt-association1]
}

# Associating the Private Route table 1 App Private Subnet 1
resource "aws_route_table_association" "app-private-rt-association1" {
  subnet_id      = aws_subnet.app-private-subnet1.id
  route_table_id = aws_route_table.private-rt1.id

  depends_on = [aws_route_table_association.web-private-rt-association2]
}

# Associating the Private Route table 2 App Private Subnet 2
resource "aws_route_table_association" "app-private-rt-association2" {
  subnet_id      = aws_subnet.app-private-subnet2.id
  route_table_id = aws_route_table.private-rt2.id

  depends_on = [aws_route_table_association.app-private-rt-association1]
}

# Associating the Private Route table 1 DB Private Subnet 1
resource "aws_route_table_association" "db-private-rt-association1" {
  subnet_id      = aws_subnet.db-private-subnet1.id
  route_table_id = aws_route_table.private-rt1.id

  depends_on = [aws_route_table_association.app-private-rt-association2]
}

# Associating the Private Route table 2 DB Private Subnet 2
resource "aws_route_table_association" "db-private-rt-association2" {
  subnet_id      = aws_subnet.db-private-subnet2.id
  route_table_id = aws_route_table.private-rt2.id

  depends_on = [aws_route_table_association.db-private-rt-association1]
}
