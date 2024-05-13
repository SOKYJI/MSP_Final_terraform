resource "aws_iam_role" "iam-role" {
  name               = var.iam-role
  assume_role_policy = file("${path.module}/iam-role.json")
} 

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role_v2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}