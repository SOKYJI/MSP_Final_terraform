resource "aws_s3_bucket" "web_bucket" {
  bucket = var.web-bucket-name
  acl    = "public-read"

  tags = {
    Name       = var.web-bucket-name
    owner      = "skj"
    createDate = formatdate("YYYY MM DD", timestamp())
  }
}

resource "aws_s3_bucket_object" "css_files" {
  for_each = fileset("${path.module}/static/bs5/css", "**/*.*")

  bucket       = aws_s3_bucket.web_bucket.bucket
  key          = "static/bs5/css/${each.value}"
  source       = "${path.module}/static/bs5/css/${each.value}"
  etag         = filemd5("${path.module}/static/bs5/css/${each.value}")
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "js_files" {
  for_each = fileset("${path.module}/static/bs5/js", "**/*.*")

  bucket       = aws_s3_bucket.web_bucket.bucket
  key          = "static/bs5/js/${each.value}"
  source       = "${path.module}/static/bs5/js/${each.value}"
  etag         = filemd5("${path.module}/static/bs5/js/${each.value}")
  content_type = "application/javascript"
}

resource "aws_s3_bucket_object" "image" {
  for_each = fileset("${path.module}/static/bs5/image", "**/*.*")

  bucket       = aws_s3_bucket.web_bucket.bucket
  key          = "static/bs5/image/${each.value}"
  source       = "${path.module}/static/bs5/image/${each.value}"
  etag         = filemd5("${path.module}/static/bs5/image/${each.value}")

  content_type = "image/png"  
}