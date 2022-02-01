locals {
  superset_values = {
    host                 = var.superset_db_host
    user                 = var.superset_db_user
    password             = var.superset_db_password
    database             = var.superset_db_database
    port                 = var.superset_db_port
  }
}

resource "helm_release" "superset" {
  name       = "superset"
  namespace   = var.kubernetes_namespace
  repository = "https://apache.github.io/superset"
  chart       = "superset"
  version   = "0.5.3"
  wait      = false
  values = [
    templatefile("${path.module}/superset.values.tftpl", local.superset_values)
  ]
  depends_on = [helm_release.meltano]
}