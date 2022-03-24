
output "aws_region" {
  value       = var.aws_region
  description = "AWS region deployed to."
}

output "kubernetes_cluster" {
  value       = local.kubernetes_cluster
  description = "Map of created EKS cluster outputs."
  sensitive   = true
}

output "meltano_database" {
  value       = local.meltano_database
  description = "Map of created RDS database outputs for use by Meltano."
  sensitive   = true
}

output "airflow_database" {
  value       = local.airflow_database
  description = "Map of created RDS database outputs for use by Airflow."
  sensitive   = true
}

output "superset_database" {
  value       = local.superset_database
  description = "Map of created RDS database outputs for use by Meltano."
  sensitive   = true
}

output "meltano_registry" {
  value       = local.meltano_registry
  description = "Map of created ECR registry outputs for use by Meltano."
  sensitive   = true
}

output "airflow_registry" {
  value       = local.airflow_registry
  description = "Map of created ECR registry outputs for use by Airflow."
  sensitive   = true
}

output "vpc" {
  value       = local.vpc
  description = "Map of created VPC outputs."
}