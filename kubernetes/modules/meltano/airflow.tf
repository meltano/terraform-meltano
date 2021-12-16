locals {
  airflow_values = {
    # The 'released_at' label is a way to force helm_release to deploy new containers every time.
    # Without this, helm_release only updates the release if the chart version (in Chart.yaml) has been updated.
    released_at          = formatdate("YYYYMMDDhhmmss", timestamp())
    fernet_key           = var.airflow_fernet_key
    webserver_secret_key = var.airflow_webserver_secret_key
    image_repository_url = var.airflow_image_repository_url
    image_tag            = var.airflow_image_tag
    host                 = var.airflow_db_host
    user                 = var.airflow_db_user
    password             = var.airflow_db_password
    database             = var.airflow_db_database
    port                 = var.airflow_db_port
    protocol             = var.airflow_db_protocol
    logs_pvc_claim_name  = var.airflow_logs_pvc_claim_name
    # meltano operator vars
    aws_region                   = var.aws_region
    meltano_image_repository_url = var.meltano_image_repository_url
    meltano_image_tag            = var.meltano_image_tag
    meltano_namespace            = var.kubernetes_namespace
  }
}

resource "helm_release" "airflow" {
  name        = "airflow"
  namespace   = var.kubernetes_namespace
  repository  = "https://airflow.apache.org"
  chart       = "airflow"
  version     = "1.3.0"
  max_history = 10
  wait        = false
  values = [
    templatefile("${path.module}/airflow.values.tftpl", local.airflow_values),
  ]
  depends_on = [helm_release.meltano]
}
