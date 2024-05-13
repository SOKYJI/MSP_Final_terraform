# cluster
variable "web-cluster-name" {}
variable "app-cluster-name" {}
# task
variable "web-container-name" {}
variable "app-container-name" {}
variable "web-image-name" {}
variable "app-image-name" {}
variable "web-port" {}
variable "app-port" {}
variable "web-alb-dns-name" {}
variable "app-alb-dns-name" {}
variable "web-task-name" {}
variable "app-task-name" {}
# service
variable "web-service-name" {}
variable "app-service-name" {}
# data
variable "web-sg-name" {}
variable "app-sg-name" {}
variable "web-tg-name" {}
variable "app-tg-name" {}
variable "web-private-subnet-name1" {}
variable "web-private-subnet-name2" {}
variable "app-private-subnet-name1" {}
variable "app-private-subnet-name2" {}
# variable "private-subnet-name" {}

variable "db-user" {}
variable "db-password" {}
variable "db-name" {}

variable "db-endpoint" {}
variable "ecs-task-role-arn" {}
variable "aws-region" {}
variable "ecs-web-log-group" {}
variable "ecs-app-log-group" {}


