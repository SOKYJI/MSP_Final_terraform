data "aws_route53_zone" "existing_zone" {
  name         = "${var.domain-name}."
  private_zone = false
}