output "acm_lb_certificate_arn" {
  description = "The ARN of the ACM Certificate ARN for loadbalancer."
  value       = aws_acm_certificate.cert_lb.arn
}