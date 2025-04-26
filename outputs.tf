output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  description = "Endpoint for RDS instance"
  value       = aws_db_instance.default.address
}

output "rds_port" {
  description = "Port for RDS instance"
  value       = aws_db_instance.default.port
}

output "rds_username" {
  description = "Username for RDS instance"
  value       = aws_db_instance.default.username
  sensitive   = true
}