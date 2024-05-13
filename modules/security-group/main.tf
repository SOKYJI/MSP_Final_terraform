##############################################
#        Web (ALB, Security Group)
##############################################
resource "aws_security_group" "web-alb-sg" {
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow HTTP, HTTPS and SSH for World"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name       = var.web-alb-sg-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }

  depends_on = [data.aws_vpc.vpc]
}

resource "aws_security_group" "web-tier-sg" {
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow traffic from Web ALB to Web Tier"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web-alb-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web-alb-sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web-alb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name       = var.web-sg-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }

  depends_on = [aws_security_group.web-alb-sg]
}

##############################################
#        APP (ALB, Security Group)
##############################################
resource "aws_security_group" "app-alb-sg" {
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow HTTP, HTTPS and SSH traffic to App ALB from Web"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.web-tier-sg.id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.web-tier-sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.web-tier-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.web-tier-sg.id]
  }

  # Outbound internet access
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name       = var.app-alb-sg-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }

  depends_on = [aws_security_group.web-tier-sg]
}

resource "aws_security_group" "app-tier-sg" {
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow traffic from App ALB to App Tier"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.app-alb-sg.id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.app-alb-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.app-alb-sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.app-alb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name       = var.app-sg-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }

  depends_on = [aws_security_group.app-alb-sg]
}

##############################################
#                    DB
##############################################
# Creating Security Group for RDS Instances Tier With only access to App-Tier ALB
resource "aws_security_group" "db-sg" {
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow MySQL traffic from App Tier"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app-tier-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name       = var.db-sg-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }

  depends_on = [aws_security_group.app-tier-sg]
}