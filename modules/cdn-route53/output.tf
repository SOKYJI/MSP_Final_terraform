output "name_server" {
  value = data.aws_route53_zone.existing_zone.name_servers
}

