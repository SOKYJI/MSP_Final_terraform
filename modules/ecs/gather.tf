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
data "aws_subnet" "web-private-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.web-private-subnet-name1]
  }
}

data "aws_subnet" "web-private-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.web-private-subnet-name2]
  }
}
data "aws_subnet" "app-private-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.app-private-subnet-name1]
  }
}

data "aws_subnet" "app-private-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.app-private-subnet-name2]
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

data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_cloudwatch_log_group" "ecs-web-log-group" {
  name = "/ecs/${var.web-task-name}"
}

data "aws_cloudwatch_log_group" "ecs-app-log-group" {
  name = "/ecs/${var.app-task-name}"
}
# data "template_file" "service" {
#   template = file(var.tpl_path)

#   vars = {
#     region             = var.region
#     aws_ecr_repository = aws_ecr_repository.repo.repository_url
#     tag                = "latest"
#     container_port     = var.container_port
#     host_port          = var.host_port
#     app_name           = var.app_name
#     env_suffix         = var.env_suffix
#   }
# }