
output "aws_region" {
  value = var.aws_region
}

output "kubernetes_cluster" {
  value = local.kubernetes_cluster
}

output "meltano_database" {
  value = local.meltano_database
}

output "airflow_database" {
  value = local.airflow_database
}

output "airflow_registry" {
  value = local.airflow_registry
}

output "meltano_registry" {
  value = local.meltano_registry
}

output "superset_database" {
  value = local.superset_database
}

output "vpc" {
  value = local.vpc
}