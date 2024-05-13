# VPC
variable "VPC-NAME" {}
variable "VPC-CIDR" {}
variable "IGW-NAME" {}
variable "PUBLIC-CIDR1" {}
variable "PUBLIC-SUBNET1" {}
variable "PUBLIC-CIDR2" {}
variable "PUBLIC-SUBNET2" {}
variable "WEB-PRIVATE-CIDR1" {}
variable "WEB-PRIVATE-SUBNET1" {}
variable "WEB-PRIVATE-CIDR2" {}
variable "WEB-PRIVATE-SUBNET2" {}
variable "APP-PRIVATE-CIDR1" {}
variable "APP-PRIVATE-SUBNET1" {}
variable "APP-PRIVATE-CIDR2" {}
variable "APP-PRIVATE-SUBNET2" {}
variable "DB-PRIVATE-CIDR1" {}
variable "DB-PRIVATE-SUBNET1" {}
variable "DB-PRIVATE-CIDR2" {}
variable "DB-PRIVATE-SUBNET2" {}
variable "EIP-NAME1" {}
variable "EIP-NAME2" {}
variable "NGW-NAME1" {}
variable "NGW-NAME2" {}
variable "PUBLIC-RT-NAME1" {}
variable "PUBLIC-RT-NAME2" {}
variable "PRIVATE-RT-NAME1" {}
variable "PRIVATE-RT-NAME2" {}

# SECURITY GROUP
variable "WEB-ALB-SG-NAME" {}
variable "APP-ALB-SG-NAME" {}
variable "WEB-SG-NAME" {}
variable "APP-SG-NAME" {}
variable "DB-SG-NAME" {}

# RDS
variable "SG-NAME" {}
variable "RDS-USERNAME" {}
variable "RDS-PWD" {}
variable "DB-NAME" {}
variable "RDS-NAME" {}

variable "DB-USER" {}
variable "DB-PASSWORD" {}

# ALB
variable "WEB-TG-NAME" {}
variable "WEB-ALB-NAME" {}
variable "APP-TG-NAME" {}
variable "APP-ALB-NAME" {}

# IAM
variable "IAM-ROLE" {}
variable "IAM-POLICY" {}
variable "INSTANCE-PROFILE-NAME" {}

# AUTOSCALING
variable "WEB-AMI-NAME" {}
variable "WEB-LAUNCH-TEMPLATE-NAME" {}
variable "WEB-ASG-NAME" {}
variable "APP-AMI-NAME" {}
variable "APP-LAUNCH-TEMPLATE-NAME" {}
variable "APP-ASG-NAME" {}


variable "ECR-NAME" {}
##### ECS ############
# CLUSTER
variable "WEB-CLUSTER-NAME" {}
variable "APP-CLUSTER-NAME" {}
#TASK
variable "WEB-CONTAINER-NAME" {}
variable "APP-CONTAINER-NAME" {}
variable "WEB-IMAGE-NAME" {}
variable "APP-IMAGE-NAME" {}
variable "WEB-PORT" {}
variable "APP-PORT" {}
# variable "web-alb-dns-name" {}
# variable "app-alb-dns-name" {}
variable "WEB-TASK-NAME" {}
variable "APP-TASK-NAME" {}
#SERVICE
variable "WEB-SERVICE-NAME" {}
variable "APP-SERVICE-NAME" {}

######################

# CLOUDFFRONT
variable "DOMAIN-NAME" {}
variable "CDN-NAME" {}

# WAF
variable "WEB-ACL-NAME" {}

# ami
variable "IMAGE-ID" {}

# logs
variable "ECS-WEB-LOG-GROUP-NAME" {}
variable "ECS-APP-LOG-GROUP-NAME" {}
variable "AWS-REGION" {}

# s3
variable "WEB-BUCKET-NAME" {}