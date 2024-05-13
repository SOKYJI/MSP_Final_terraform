# data "aws_route53_zone" "zone" {
#   name         = var.domain-name
#   private_zone = false
# }

data "aws_lb" "web_elb" {
  name = var.web-alb-name
}

data "aws_lb" "app_elb" {
  name = var.app-alb-name
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc-name]
  }
}

data "aws_route53_zone" "existing_zone" {
  name         = "${var.domain-name}."
  private_zone = false
}


data "aws_s3_bucket" "web_bucket" {
  bucket = var.web-bucket-name
}

# data "aws_s3_bucket_object" "css_files" {
#   for_each = fileset("${path.module}/static/bs5/css", "**/*.*")
#   bucket   = data.aws_s3_bucket.web_bucket.bucket
#   key      = "static/bs5/css/${each.value}"
# }

# data "aws_s3_bucket_object" "js_files" {
#   for_each = fileset("${path.module}/static/bs5/js", "**/*.*")
#   bucket   = data.aws_s3_bucket.web_bucket.bucket
#   key      = "static/bs5/js/${each.value}"
# }