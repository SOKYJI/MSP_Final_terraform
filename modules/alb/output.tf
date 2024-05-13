# output "web_alb_dns_name" {
#   value       = try(aws_lb.web-elb.dns_name)
#   description = "DNS Name for the Web ALB"
# }

output "app_alb_dns_name" {
  value       = try(aws_lb.app-elb.dns_name)
  description = "DNS Name for the App ALB"
}
