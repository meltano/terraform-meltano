
output "aws_region" {
  value = var.aws_region
}

output "kubernetes_cluster" {
  value     = local.kubernetes_cluster
  sensitive = true
}

output "meltano_database" {
  value     = local.meltano_database
  sensitive = true
}

output "airflow_database" {
  value     = local.airflow_database
  sensitive = true
}

output "airflow_registry" {
  value     = local.airflow_registry
  sensitive = true
}

output "meltano_registry" {
  value     = local.meltano_registry
  sensitive = true
}

output "superset_database" {
  value     = local.superset_database
  sensitive = true
}

output "vpc" {
  value = local.vpc
}