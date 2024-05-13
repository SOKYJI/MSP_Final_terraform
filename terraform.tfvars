# VPC
VPC-NAME = "Song-Three-Tier-VPC"
VPC-CIDR = "10.0.0.0/16"
IGW-NAME = "Interet-Gateway"

# Public
PUBLIC-CIDR1   = "10.0.1.0/24"
PUBLIC-SUBNET1 = "Public-Subnet1"
PUBLIC-CIDR2   = "10.0.2.0/24"
PUBLIC-SUBNET2 = "Public-Subnet2"

# Web-private
WEB-PRIVATE-CIDR1   = "10.0.4.0/22"
WEB-PRIVATE-SUBNET1 = "Web-Private-Subnet1"
WEB-PRIVATE-CIDR2   = "10.0.16.0/22"
WEB-PRIVATE-SUBNET2 = "Web-Private-Subnet2"

# App-private
APP-PRIVATE-CIDR1   = "10.0.8.0/22"
APP-PRIVATE-SUBNET1 = "App-Private-Subnet1"
APP-PRIVATE-CIDR2   = "10.0.20.0/22"
APP-PRIVATE-SUBNET2 = "App-Private-Subnet2"

# DB-private
DB-PRIVATE-CIDR1   = "10.0.12.0/22"
DB-PRIVATE-SUBNET1 = "DB-Private-Subnet1"
DB-PRIVATE-CIDR2   = "10.0.24.0/22"
DB-PRIVATE-SUBNET2 = "DB-Private-Subnet2"

# NAT
EIP-NAME1 = "Elastic-IP1"
EIP-NAME2 = "Elastic-IP2"
NGW-NAME1 = "NAT1"
NGW-NAME2 = "NAT2"

# ROUTE TABLE
PUBLIC-RT-NAME1  = "Public-Route-table1"
PUBLIC-RT-NAME2  = "Public-Route-table2"
PRIVATE-RT-NAME1 = "Private-Route-table1"
PRIVATE-RT-NAME2 = "Private-Route-table2"

# SECURITY GROUP
WEB-ALB-SG-NAME = "web-alb-sg"
APP-ALB-SG-NAME = "app-alb-sg"
WEB-SG-NAME     = "web-sg"
APP-SG-NAME     = "app-sg"
DB-SG-NAME      = "db-sg"

# RDS
SG-NAME      = "rds-sg"
RDS-USERNAME = "admin"
RDS-PWD      = "admin1234"
DB-NAME      = "mydb"
RDS-NAME     = "songRDS"

DB-USER     = "admin"
DB-PASSWORD = "admin1234"

# ALB
WEB-TG-NAME  = "SONG-Web-TG"
WEB-ALB-NAME = "SONG-Web-elb"
APP-TG-NAME  = "SONG-App-TG"
APP-ALB-NAME = "SONG-App-elb"

# IAM
IAM-ROLE              = "song-iam-role-for-ec2-SSM"
IAM-POLICY            = "song-iam-policy-for-ec2-SSM"
INSTANCE-PROFILE-NAME = "song-iam-instance-profile-for-ec2-SSM"

# AUTOSCALING
WEB-AMI-NAME             = "Web-New-AMI"
WEB-LAUNCH-TEMPLATE-NAME = "Web-template"
WEB-ASG-NAME             = "Web-ASG"

APP-AMI-NAME             = "App-New-AMI"
APP-LAUNCH-TEMPLATE-NAME = "App-template"
APP-ASG-NAME             = "App-ASG"
ECR-NAME                 = "Ecr-song"
# CLUSTER
WEB-CLUSTER-NAME = "Web-Cluster"
APP-CLUSTER-NAME = "App-Cluster"
#TASK
WEB-CONTAINER-NAME = "Ecs-Web-Container"
APP-CONTAINER-NAME = "Ecs-App-Container"
WEB-IMAGE-NAME     = "992382777416.dkr.ecr.ap-southeast-1.amazonaws.com/song-test:web"
APP-IMAGE-NAME     = "992382777416.dkr.ecr.ap-southeast-1.amazonaws.com/song-test:app"
WEB-PORT           = 80
APP-PORT           = 8080
# WEB-ALB-DNS-NAME   = "web-alb-dns-name"
# APP-ALB-DNS-NAME    = "app-alb-dns-name"
WEB-TASK-NAME = "Web-task"
APP-TASK-NAME = "App-task"
#SERVICE
WEB-SERVICE-NAME = "ecs-web-service"
APP-SERVICE-NAME = "ecs-app-service"

# CLOUDFRONT
DOMAIN-NAME = "kyeongjin.store"
CDN-NAME    = "SONG-CDN"

# WAF
WEB-ACL-NAME = "SONG-WAF"

# AMI
IMAGE-ID = "ami-0910e4162f162c238"

# LOGS
ECS-WEB-LOG-GROUP-NAME = "Ecs-web-log-group"
ECS-APP-LOG-GROUP-NAME = "Ecs-app-log-group"
AWS-REGION             = "ap-southeast-1"

# S3
WEB-BUCKET-NAME = "Web-bucket"