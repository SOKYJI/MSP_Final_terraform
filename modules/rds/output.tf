output "db-endpoint" {
  value       = aws_rds_cluster.aurora_cluster.endpoint
  description = "The endpoint of the Aurora RDS cluster"
}
