# ##############################################
# #                    WEB
# ##############################################
# # Creating ALB for Web Tier
# resource "aws_lb" "web-elb" {
#   name                       = var.web-alb-name
#   internal                   = false
#   load_balancer_type         = "application"
#   subnets                    = [data.aws_subnet.public-subnet1.id, data.aws_subnet.public-subnet2.id]
#   security_groups            = [data.aws_security_group.web-alb-sg.id]
#   ip_address_type            = "ipv4"
#   enable_deletion_protection = false #삭제 방지 활성화 
#   tags = {
#     Name       = var.web-alb-name
#     owner      = "skj"
#     createDate = formatdate("YYYY MM DD", timestamp())
#   }
# }

# # The flow of traffic is:
# #   Internet -> ALB -> Listener -> Target Group -> ECS Service
# # Creating Target Group for Web-Tier 
# resource "aws_lb_target_group" "web-tg" {
#   name = var.web-tg-name
#   health_check {
#     enabled             = true
#     interval            = 30
#     path                = "/static/bs5/css/bootstrap.min.css"
#     protocol            = "HTTP"
#     timeout             = 10
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
#   target_type = "ip"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = data.aws_vpc.vpc.id

#   tags = {
#     Name       = var.web-tg-name
#     owner      = "skj"
#     createDate = formatdate("YYYY MM DD", timestamp())
#   }

#   lifecycle {
#     prevent_destroy = false
#   }
#   depends_on = [aws_lb.web-elb]
# }


# # Creating ALB listener with port 80 and attaching it to Web-Tier Target Group
# resource "aws_lb_listener" "web-alb-listener" {
#   load_balancer_arn = aws_lb.web-elb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.acm-certs-arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.web-tg.arn
#   }

#   depends_on = [aws_lb.web-elb]
# }

# # resource "aws_lb_listener" "web-alb-listener-http" {
# #   load_balancer_arn = aws_lb.web-elb.arn
# #   port              = 80
# #   protocol          = "HTTP"

# #   default_action {
# #     type = "redirect"
# #     redirect {
# #       protocol   = "HTTPS"
# #       port       = "443"
# #       status_code = "HTTP_301"
# #     }
# #   }

# #   depends_on = [aws_lb.web-elb]
# # }
##############################################
#                    APP
##############################################
# Creating ALB for APP Tier
resource "aws_lb" "app-elb" {
  name                       = var.app-alb-name
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [data.aws_subnet.public-subnet1.id, data.aws_subnet.public-subnet2.id]
  security_groups            = [data.aws_security_group.app-alb-sg.id]
  ip_address_type            = "ipv4"
  enable_deletion_protection = false #삭제 방지 활성화 
  tags = {
    Name       = var.app-alb-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }
}

# Creating Target Group for APP-Tier 
resource "aws_lb_target_group" "app-tg" {
  name = var.app-tg-name
  target_type = "ip"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name       = var.app-tg-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }

  lifecycle {
    prevent_destroy = false
  }
  
  depends_on = [aws_lb.app-elb]
}


# Creating ALB listener with port 80 and attaching it to APP-Tier Target Group
resource "aws_lb_listener" "app-alb-listener" {
  load_balancer_arn = aws_lb.app-elb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm-certs-arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }

  depends_on = [aws_lb.app-elb]
}

resource "aws_lb_listener" "app-alb-listener-http-redirect" {
  load_balancer_arn = aws_lb.app-elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol   = "HTTPS"
      port       = "443"  # Ensure the app-tier has HTTPS configured on 443 if used
      status_code = "HTTP_301"
    }
  }

  depends_on = [aws_lb.app-elb]
}