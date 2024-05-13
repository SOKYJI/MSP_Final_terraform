resource "aws_cloudfront_distribution" "cdn-app-alb-distribution" {
  # provider = aws.virginia
  origin {
    domain_name = var.domain-name
    origin_id   = "my-web-elb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

  }

  aliases         = [var.domain-name, "www.${var.domain-name}", "app.${var.domain-name}"]
  enabled         = true
  is_ipv6_enabled = true
  comment         = "CDN ALB Distribution"
  price_class     = "PriceClass_100"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "my-web-elb"

    forwarded_values {
      query_string = false
      headers      = ["*"]
      cookies {
        forward = "none"
      }

    }
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm-certs-arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  web_acl_id = var.waf-acl-arn

  tags = {
    Name = var.cdn-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }

  # depends_on = [aws_acm_certificate_validation.cert]
}



########################################
#            S3_web_bucket
########################################
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${data.aws_s3_bucket.web_bucket.bucket_regional_domain_name}"
    origin_id   = "S3-${data.aws_s3_bucket.web_bucket.id}"
  }

  enabled = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${data.aws_s3_bucket.web_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm-certs-arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name       = "CF-${var.domain-name}"
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }
}