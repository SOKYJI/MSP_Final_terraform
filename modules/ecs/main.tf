# # Create ECS cluster
# resource "aws_ecs_cluster" "web_cluster" {
#   name = var.web-cluster-name
#   tags = {
#     Name       = var.web-cluster-name
#     owner      = "skj"
#     createDate = formatdate("YYYY MM DD", timestamp())
#   }
# }
resource "aws_ecs_cluster" "app_cluster" {
  name = var.app-cluster-name
  tags = {
    Name       = var.app-cluster-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }
}

# # Create ECS task definition for web service
# resource "aws_ecs_task_definition" "web_task_definition" {
#   family                   = "web-task-family"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = 1024
#   memory                   = 2048
#   execution_role_arn       = var.ecs-task-role-arn
#   container_definitions = jsonencode([
#     {
#       "name" : "${var.web-container-name}",
#       "image" : "${var.web-image-name}",
#       "cpu" : 256,
#       "memory" : 512,
#       "portMappings" : [
#         {
#           "containerPort" : "${var.web-port}",
#           "protocol" : "tcp"
#         }
#       ],
#       "environment" : [
#         {
#           "name" : "app_endpoint",
#           "value" : "web-alb-dns-name"
#         }
#       ]
#       "logConfiguration" : {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = data.aws_cloudwatch_log_group.ecs-web-log-group.name
#           awslogs-region        = var.aws-region
#           awslogs-stream-prefix = "ecs"
#         }
#       }
#     }
#   ])
#   tags = {
#     Name       = var.web-task-name
#     owner      = "skj"
#     createDate = formatdate("YYYY MM DD", timestamp())
#   }
# }
# Create ECS task definition for app service
resource "aws_ecs_task_definition" "app_task_definition" {
  family                   = "app-task-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = var.ecs-task-role-arn
  container_definitions = jsonencode([
    {
      "name" : "${var.app-container-name}",
      "image" : "${var.app-image-name}",
      "cpu" : 256,
      "memory" : 512,
      "portMappings" : [
        {
          "containerPort" : "${var.app-port}",
          "protocol" : "tcp"
        }
      ]
      "environment" : [
        {
          "name" : "DB_HOST",
          "value" : "${var.db-endpoint}"
        },
        {
          "name" : "DB_USER",
          "value" : "${var.db-user}"
        },
        {
          "name" : "DB_PASSWORD",
          "value" : "${var.db-password}"
        },
        {
          "name" : "DB_NAME",
          "value" : "${var.db-name}"
        }
      ]
      "portMappings" : [{
        containerPort = 8080,
        # hostPort      = 80
      }]
      "logConfiguration" : {
        logDriver = "awslogs"
        options = {
          awslogs-group         = data.aws_cloudwatch_log_group.ecs-app-log-group.name
          awslogs-region        = var.aws-region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
  tags = {
    Name       = var.app-task-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }
}

# resource "aws_ecs_service" "web-service" {
#   name            = var.web-service-name
#   cluster         = aws_ecs_cluster.web_cluster.id
#   task_definition = aws_ecs_task_definition.web_task_definition.arn
#   desired_count   = 2
#   launch_type     = "FARGATE"
#   network_configuration {
#     subnets          = [data.aws_subnet.web-private-subnet1.id, data.aws_subnet.web-private-subnet2.id]
#     security_groups  = [data.aws_security_group.web-sg.id]
#     assign_public_ip = false
#   }
#   load_balancer {
#     target_group_arn = data.aws_lb_target_group.web-tg.arn
#     container_name   = var.web-container-name
#     container_port   = var.web-port
#   }
#   tags = {
#     Name       = var.web-service-name
#     owner      = "skj"
#     createDate = formatdate("YYYY MM DD", timestamp())
#   }
#   depends_on = [aws_ecs_task_definition.web_task_definition]
# }

resource "aws_ecs_service" "app-service" {
  name            = var.app-service-name
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [data.aws_subnet.app-private-subnet1.id, data.aws_subnet.app-private-subnet2.id]
    security_groups  = [data.aws_security_group.app-sg.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = data.aws_lb_target_group.app-tg.arn
    container_name   = var.app-container-name
    container_port   = var.app-port
  }
  tags = {
    Name       = var.app-service-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }
  depends_on = [aws_ecs_task_definition.app_task_definition]
}