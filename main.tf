terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
      #   configuration_aliases = [aws.virginia]
    }
  }
}

provider "aws" {
  # profile = "default"
  region = "ap-southeast-1"

}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  vpc-name            = var.VPC-NAME
  vpc-cidr            = var.VPC-CIDR
  igw-name            = var.IGW-NAME
  public-cidr1        = var.PUBLIC-CIDR1
  public-subnet1      = var.PUBLIC-SUBNET1
  public-cidr2        = var.PUBLIC-CIDR2
  public-subnet2      = var.PUBLIC-SUBNET2
  web-private-cidr1   = var.WEB-PRIVATE-CIDR1
  web-private-subnet1 = var.WEB-PRIVATE-SUBNET1
  web-private-cidr2   = var.WEB-PRIVATE-CIDR2
  web-private-subnet2 = var.WEB-PRIVATE-SUBNET2
  app-private-cidr1   = var.APP-PRIVATE-CIDR1
  app-private-subnet1 = var.APP-PRIVATE-SUBNET1
  app-private-cidr2   = var.APP-PRIVATE-CIDR2
  app-private-subnet2 = var.APP-PRIVATE-SUBNET2
  db-private-cidr1    = var.DB-PRIVATE-CIDR1
  db-private-subnet1  = var.DB-PRIVATE-SUBNET1
  db-private-cidr2    = var.DB-PRIVATE-CIDR2
  db-private-subnet2  = var.DB-PRIVATE-SUBNET2
  eip-name1           = var.EIP-NAME1
  eip-name2           = var.EIP-NAME2

  ngw-name1        = var.NGW-NAME1
  ngw-name2        = var.NGW-NAME2
  public-rt-name1  = var.PUBLIC-RT-NAME1
  public-rt-name2  = var.PUBLIC-RT-NAME2
  private-rt-name1 = var.PRIVATE-RT-NAME1
  private-rt-name2 = var.PRIVATE-RT-NAME2
}

module "security-group" {
  source = "./modules/security-group"

  vpc-name = var.VPC-NAME

  web-alb-sg-name = var.WEB-ALB-SG-NAME
  app-alb-sg-name = var.APP-ALB-SG-NAME
  web-sg-name     = var.WEB-SG-NAME
  app-sg-name     = var.APP-SG-NAME
  db-sg-name      = var.DB-SG-NAME

  depends_on = [module.vpc]
}
module "s3" {
  source = "./modules/s3"

  web-bucket-name = var.WEB-BUCKET-NAME

}
module "rds" {
  source = "./modules/rds"

  sg-name                 = var.SG-NAME
  db-private-subnet-name1 = var.DB-PRIVATE-SUBNET1
  db-private-subnet-name2 = var.DB-PRIVATE-SUBNET2
  db-sg-name              = var.DB-SG-NAME
  rds-username            = var.RDS-USERNAME
  rds-pwd                 = var.RDS-PWD
  db-name                 = var.DB-NAME
  rds-name                = var.RDS-NAME
  vpc-name                = var.VPC-NAME

  depends_on = [module.security-group]
}

module "acm" {
  source = "./modules/acm"

  providers = {
    aws = aws.us-east-1
  }
  domain-name = var.DOMAIN-NAME

  depends_on = [module.rds]
}

module "acm_lb" {
  source = "./modules/acm_lb"

  domain-name = var.DOMAIN-NAME

  depends_on = [module.rds]
}

module "alb" {
  source = "./modules/alb"

  public-subnet-name1      = var.PUBLIC-SUBNET1
  public-subnet-name2      = var.PUBLIC-SUBNET2
  app-private-subnet-name1 = var.APP-PRIVATE-SUBNET1
  app-private-subnet-name2 = var.APP-PRIVATE-SUBNET2
  vpc-name                 = var.VPC-NAME
  web-alb-name             = var.WEB-ALB-NAME
  web-alb-sg-name          = var.WEB-ALB-SG-NAME
  web-tg-name              = var.WEB-TG-NAME
  app-alb-name             = var.APP-ALB-NAME
  app-tg-name              = var.APP-TG-NAME
  app-alb-sg-name          = var.APP-ALB-SG-NAME

  acm-certs-arn = module.acm_lb.acm_lb_certificate_arn
  # depends_on = [module.rds]
  depends_on = [module.acm_lb]
}

module "iam" {
  source = "./modules/iam"

  iam-role              = var.IAM-ROLE
  iam-policy            = var.IAM-POLICY
  instance-profile-name = var.INSTANCE-PROFILE-NAME

  depends_on = [module.alb]
}

# module "ecr" {
#   source   = "./modules/ecr"
#   ecr-name = var.ECR-NAME
# }

module "ecs" {
  source           = "./modules/ecs"
  web-cluster-name = var.WEB-CLUSTER-NAME
  app-cluster-name = var.APP-CLUSTER-NAME

  web-container-name = var.WEB-CONTAINER-NAME
  app-container-name = var.APP-CONTAINER-NAME
  web-image-name     = var.WEB-IMAGE-NAME
  app-image-name     = var.APP-IMAGE-NAME
  web-port           = var.WEB-PORT
  app-port           = var.APP-PORT
  web-alb-dns-name   = module.alb.app_alb_dns_name
  app-alb-dns-name   = module.alb.app_alb_dns_name
  web-task-name      = var.WEB-TASK-NAME
  app-task-name      = var.APP-TASK-NAME
  web-service-name   = var.WEB-SERVICE-NAME
  app-service-name   = var.APP-SERVICE-NAME

  web-sg-name              = var.WEB-SG-NAME
  app-sg-name              = var.APP-SG-NAME
  web-tg-name              = var.WEB-TG-NAME
  app-tg-name              = var.APP-TG-NAME
  web-private-subnet-name1 = var.WEB-PRIVATE-SUBNET1
  web-private-subnet-name2 = var.WEB-PRIVATE-SUBNET2
  app-private-subnet-name1 = var.APP-PRIVATE-SUBNET1
  app-private-subnet-name2 = var.APP-PRIVATE-SUBNET2

  db-name     = var.DB-NAME
  db-password = var.DB-PASSWORD
  db-user     = var.DB-USER

  db-endpoint       = module.rds.db-endpoint
  ecs-task-role-arn = module.iam.ecs_task_execution_role_arn
  aws-region        = var.AWS-REGION
  ecs-web-log-group = var.ECS-WEB-LOG-GROUP-NAME
  ecs-app-log-group = var.ECS-APP-LOG-GROUP-NAME

  depends_on = [module.iam]

}

# module "autoscaling" {
#   source = "./modules/autoscaling"

#   web-ami-name             = var.WEB-AMI-NAME
#   app-ami-name             = var.APP-AMI-NAME
#   web-launch-template-name = var.WEB-LAUNCH-TEMPLATE-NAME
#   app-launch-template-name = var.APP-LAUNCH-TEMPLATE-NAME
#   instance-profile-name    = var.INSTANCE-PROFILE-NAME
#   web-sg-name              = var.WEB-SG-NAME
#   app-sg-name              = var.APP-SG-NAME
#   web-tg-name              = var.WEB-TG-NAME
#   app-tg-name              = var.APP-TG-NAME
#   iam-role                 = var.IAM-ROLE
#   public-subnet1           = var.PUBLIC-SUBNET1
#   public-subnet2           = var.PUBLIC-SUBNET2
#   web-private-subnet1      = var.WEB-PRIVATE-SUBNET1
#   web-private-subnet2      = var.WEB-PRIVATE-SUBNET2
#   app-private-subnet1      = var.APP-PRIVATE-SUBNET1
#   app-private-subnet2      = var.APP-PRIVATE-SUBNET2
#   web-asg-name             = var.WEB-ASG-NAME
#   app-asg-name             = var.APP-ASG-NAME
#   image-id                 = var.IMAGE-ID

#   depends_on = [module.iam]
# }

module "waf" {
  source = "./modules/waf"

  providers = {
    aws = aws.us-east-1
  }

  web_acl_name = var.WEB-ACL-NAME

  depends_on = [module.ecs]
}

module "cdn-route53" {
  source = "./modules/cdn-route53"

  # providers = {
  #   aws = aws.us-east-1
  # }

  domain-name     = var.DOMAIN-NAME
  web-alb-name    = var.WEB-ALB-NAME
  app-alb-name    = var.APP-ALB-NAME
  vpc-name        = var.VPC-NAME
  cdn-name        = var.CDN-NAME
  waf-acl-arn     = module.waf.waf_acl_arn
  acm-certs-arn   = module.acm.acm_certificate_arn
  web-bucket-name = var.WEB-BUCKET-NAME

  depends_on = [module.waf]
}

module "logs" {
  source = "./modules/logs"

  web-task-name     = var.WEB-TASK-NAME
  app-task-name     = var.APP-TASK-NAME
  ecs-web-log-group = var.ECS-WEB-LOG-GROUP-NAME
  ecs-app-log-group = var.ECS-APP-LOG-GROUP-NAME
}