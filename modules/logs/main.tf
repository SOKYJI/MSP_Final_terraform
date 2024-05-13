resource "aws_cloudwatch_log_group" "ecs-web-log-group" {
  name              = "/ecs/${var.web-task-name}"
  retention_in_days = 30

  tags = {
    Name       = var.ecs-web-log-group
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }
}
resource "aws_cloudwatch_log_group" "ecs-app-log-group" {
  name              = "/ecs/${var.app-task-name}"
  retention_in_days = 30

  tags = {
    Name       = var.ecs-app-log-group
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }
}
# resource "aws_s3_bucket" "log_storage" {
#   bucket = "ecs-access-logs-kemist-${var.env_suffix}"
#   force_destroy = true
# }

# resource "aws_cloudwatch_log_group" "service" {
#   name = "awslogs-service-staging-${var.env_suffix}"

#   tags = {
#     Environment = var.env_suffix
#     Application = var.app_name
#   }
# }

# resource "aws_s3_bucket_acl" "lb-logs-acl" {
#   bucket = aws_s3_bucket.log_storage.id
#   acl    = "private"
# }

# data "aws_iam_policy_document" "allow-lb" {
#   statement {
#     principals {
#       type        = "Service"
#       identifiers = ["logdelivery.elb.amazonaws.com"]
#     }

#     actions = ["s3:PutObject"]

#     resources = [
#       "arn:aws:s3:::${aws_s3_bucket.log_storage.bucket}/frontend-alb/AWSLogs/${var.account_id}/*"
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "s3:x-amz-acl"

#       values = [
#         "bucket-owner-full-control"
#       ]
#     }
#   }
#   statement {
#     principals {
#       type        = "Service"
#       identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
#     }

#     actions = ["s3:PutObject"]

#     resources = [
#       "arn:aws:s3:::${aws_s3_bucket.log_storage.bucket}/frontend-alb/AWSLogs/${var.account_id}/*"
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "s3:x-amz-acl"

#       values = [
#         "bucket-owner-full-control"
#       ]
#     }
#   }
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${var.elb_account_id}:root"]
#     }

#     actions = ["s3:PutObject"]

## 로드밸런서의 access log를 저장할 s3 버킷과 CloudWatch group을 생성한다.
#     resources = [
#       "arn:aws:s3:::${aws_s3_bucket.log_storage.bucket}/frontend-alb/AWSLogs/${var.account_id}/*"
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "s3:x-amz-acl"

#       values = [
#         "bucket-owner-full-control"
#       ]
#     }
#   }
# }

# resource "aws_s3_bucket_policy" "allow-lb" {
#   bucket = aws_s3_bucket.log_storage.id
#   policy = data.aws_iam_policy_document.allow-lb.json
# }

# resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
#   bucket = aws_s3_bucket.log_storage.id

#   rule {
#     id      = "log_lifecycle_${var.env_suffix}"
#     status  = "Enabled"

#     expiration {
#       days = 10
#     }
#   }
# }