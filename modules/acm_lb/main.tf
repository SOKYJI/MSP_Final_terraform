resource "aws_acm_certificate" "cert_lb" {
  domain_name               = var.domain-name
  validation_method         = "DNS"
  subject_alternative_names = [var.domain-name, "app.${var.domain-name}", "www.${var.domain-name}"]

  lifecycle {
    create_before_destroy = true
  }
}

# DNS 레코드를 사용한 인증서 검증
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert_lb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = data.aws_route53_zone.existing_zone.zone_id
  ttl             = 60
}

# ACM certificate validation resource using the certificate ARN and a list of validation record FQDNs.
resource "aws_acm_certificate_validation" "cert_lb" {
  certificate_arn         = aws_acm_certificate.cert_lb.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}