# resource "aws_route53_zone" "public_zone" {
#   name = var.domain-name
#   # vpc {
#   #   vpc_id = data.aws_vpc.vpc.id
#   # }
# }

resource "aws_route53_record" "ecs_web" {
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  name    = var.domain-name
  type    = "A" # A 레코드로 설정

  alias {
    name                   = aws_cloudfront_distribution.cdn-app-alb-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cdn-app-alb-distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  name    = "app.${var.domain-name}"
  type    = "A" # A 레코드로 설정

  alias {
    name                   = data.aws_lb.app_elb.dns_name
    zone_id                = data.aws_lb.app_elb.zone_id
    evaluate_target_health = true
  }
}

# AWS Route53 record resource for the "www" subdomain. The record uses an "A" type record and an alias to the AWS CloudFront distribution with the specified domain name and hosted zone ID. The target health evaluation is set to false.
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.existing_zone.id
  name    = "www.${var.domain-name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn-app-alb-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cdn-app-alb-distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# # AWS Route53 record resource for the apex domain (root domain) with an "A" type record. The record uses an alias to the AWS CloudFront distribution with the specified domain name and hosted zone ID. The target health evaluation is set to false.
# resource "aws_route53_record" "apex" {
#   zone_id = data.aws_route53_zone.existing_zone.id
#   name    = var.domain-name
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.cdn-app-alb-distribution.domain_name
#     zone_id                = aws_cloudfront_distribution.cdn-app-alb-distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

