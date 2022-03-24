locals {
  superset_values = {
    # The 'released_at' label is a way to force helm_release to deploy new containers every time.
    # Without this, helm_release only updates the release if the chart version (in Chart.yaml) has been updated.
    released_at    = formatdate("YYYYMMDDhhmmss", timestamp())
    host           = var.superset_db_host
    user           = var.superset_db_user
    password       = var.superset_db_password
    database       = var.superset_db_database
    port           = var.superset_db_port
    admin_password = var.superset_admin_password
    dependencies   = var.superset_dependencies
    webserver_host = var.superset_webserver_host
  }
}

resource "helm_release" "superset" {
  name       = "superset"
  namespace  = var.kubernetes_namespace
  repository = "https://apache.github.io/superset"
  chart      = "superset"
  version    = "0.5.3"
  wait       = false
  values = [
    templatefile("${path.module}/superset.values.tftpl", local.superset_values)
  ]
  depends_on = [helm_release.meltano]
}