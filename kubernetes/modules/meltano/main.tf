
locals {
  database_admin_values = <<EOT
image:
  repository: ${var.airflow_image_repository_url}
  tag: ${var.airflow_image_tag}
  pullPolicy: Always
airflow:
  sql_alchemy_conn: ${var.airflow_db_uri}
EOT
}

# resource "helm_release" "database_admin" {
#   name       = "database-admin"
#   chart = "${path.module}/database-admin"
#   namespace  = "meltano"
#   version    = "0.1.1"
#   wait       = true
#   values = [
#     local.database_admin_values
#   ]
#   # This is not a chart value, but just a way to trick helm_release into running every time.
#   # Without this, helm_release only updates the release if the chart version (in Chart.yaml) has been updated
#   set {
#     name  = "timestamp"
#     value = timestamp()
#   }
# }