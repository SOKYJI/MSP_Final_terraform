# ##############################################
# #                    WEB
# ##############################################
# # Creating Launch template for Web tier AutoScaling Group
# resource "aws_launch_template" "Web-LC" {
#   name = var.web-launch-template-name
#   image_id = var.image-id
#   instance_type = "t3.micro"

#   vpc_security_group_ids = [data.aws_security_group.web-sg.id]

#   user_data = filebase64("./modules/autoscaling/web.sh")

#   iam_instance_profile {
#     name = data.aws_iam_instance_profile.instance-profile.name
#   }
#   # IMDSv2 구성 추가
#   metadata_options {
#     http_tokens = "required"  # IMDSv2를 필수로 설정
#     http_put_response_hop_limit = 5  # 토큰 PUT 요청에 대한 HTTP 응답을 네트워크를 통해 전달할 수 있는 최대 홉 수
#   }

# }

# resource "aws_autoscaling_group" "Web-ASG" {
#   name = var.web-asg-name
#   vpc_zone_identifier  = [data.aws_subnet.web-private-subnet1.id, data.aws_subnet.web-private-subnet2.id]
#   launch_template {
#     id = aws_launch_template.Web-LC.id
#     version = aws_launch_template.Web-LC.latest_version   

#   }
#   min_size             = 2
#   max_size             = 3
#   health_check_type    = "ELB"
#   health_check_grace_period = 300
#   target_group_arns    = [data.aws_lb_target_group.web-tg.arn]
#   force_delete         = true
#   tag {
#     key                 = "Name"
#     value               = "Web-ASG"
#     propagate_at_launch = true
#   }

# }

# resource "aws_autoscaling_policy" "web-custom-cpu-policy" {
#   name                   = "web-custom-cpu-policy"
#   autoscaling_group_name = aws_autoscaling_group.Web-ASG.id
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = 1
#   cooldown               = 60
#   policy_type            = "SimpleScaling"
# }


# resource "aws_cloudwatch_metric_alarm" "web-custom-cpu-alarm" {
#   alarm_name          = "web-custom-cpu-alarm"
#   alarm_description   = "alarm when cpu usage increases"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = "70"

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.Web-ASG.name
#   }
#   actions_enabled = true

#   alarm_actions = [aws_autoscaling_policy.web-custom-cpu-policy.arn]
# }


# resource "aws_autoscaling_policy" "web-custom-cpu-policy-scaledown" {
#   name                   = "web-custom-cpu-policy-scaledown"
#   autoscaling_group_name = aws_autoscaling_group.Web-ASG.id
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = -1
#   cooldown               = 60
#   policy_type            = "SimpleScaling"
# }

# resource "aws_cloudwatch_metric_alarm" "web-custom-cpu-alarm-scaledown" {
#   alarm_name          = "web-custom-cpu-alarm-scaledown"
#   alarm_description   = "alarm when cpu usage decreases"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = "50"

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.Web-ASG.name
#   }
#   actions_enabled = true

#   alarm_actions = [aws_autoscaling_policy.web-custom-cpu-policy-scaledown.arn]
# }

# ##############################################
# #                    APP
# ##############################################
# # Creating Launch template for APP tier AutoScaling Group
# resource "aws_launch_template" "App-LC" {
#   name = var.app-launch-template-name
#   image_id = var.image-id
#   instance_type = "t3.micro"

#   vpc_security_group_ids = [data.aws_security_group.app-sg.id]

#   user_data = filebase64("./modules/autoscaling/app.sh")

#   iam_instance_profile {
#     name = data.aws_iam_instance_profile.instance-profile.name
#   }
#   # IMDSv2 구성 추가
#   metadata_options {
#     http_tokens = "required"  # IMDSv2를 필수로 설정
#     http_put_response_hop_limit = 5  # 토큰 PUT 요청에 대한 HTTP 응답을 네트워크를 통해 전달할 수 있는 최대 홉 수
#   }

# }

# resource "aws_autoscaling_group" "App-ASG" {
#   name = var.app-asg-name
#   vpc_zone_identifier  = [data.aws_subnet.app-private-subnet1.id, data.aws_subnet.app-private-subnet2.id]
#   launch_template {
#     id = aws_launch_template.App-LC.id
#     version = aws_launch_template.App-LC.latest_version

#   }
#   min_size             = 2
#   max_size             = 3
#   health_check_type    = "ELB"
#   health_check_grace_period = 300
#   target_group_arns    = [data.aws_lb_target_group.app-tg.arn]
#   force_delete         = true
#   tag {
#     key                 = "Name"
#     value               = "App-ASG"
#     propagate_at_launch = true
#   }

# }

# resource "aws_autoscaling_policy" "app-custom-cpu-policy" {
#   name                   = "app-custom-cpu-policy"
#   autoscaling_group_name = aws_autoscaling_group.App-ASG.id
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = 1
#   cooldown               = 60
#   policy_type            = "SimpleScaling"
# }


# resource "aws_cloudwatch_metric_alarm" "app-custom-cpu-alarm" {
#   alarm_name          = "app-custom-cpu-alarm"
#   alarm_description   = "alarm when cpu usage increases"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = "70"

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.App-ASG.name
#   }
#   actions_enabled = true

#   alarm_actions = [aws_autoscaling_policy.app-custom-cpu-policy.arn]
# }


# resource "aws_autoscaling_policy" "app-custom-cpu-policy-scaledown" {
#   name                   = "app-custom-cpu-policy-scaledown"
#   autoscaling_group_name = aws_autoscaling_group.App-ASG.id
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = -1
#   cooldown               = 60
#   policy_type            = "SimpleScaling"
# }

# resource "aws_cloudwatch_metric_alarm" "app-custom-cpu-alarm-scaledown" {
#   alarm_name          = "app-custom-cpu-alarm-scaledown"
#   alarm_description   = "alarm when cpu usage decreases"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = "50"

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.App-ASG.name
#   }
#   actions_enabled = true

#   alarm_actions = [aws_autoscaling_policy.app-custom-cpu-policy-scaledown.arn]
# }