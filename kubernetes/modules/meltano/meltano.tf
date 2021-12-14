locals {
  meltano_values = <<EOT
extraEnv: []

meltano:
  database_uri: ${var.meltano_db_uri}

image:
  repository: ${var.meltano_image_repository_url}
  tag: ${var.meltano_image_tag}

EOT
}

resource "helm_release" "meltano" {
  name       = "meltano"
  repository = "https://meltano.gitlab.io/infra/helm-meltano/meltano"
  chart      = "meltano"
  namespace  = "meltano"
  version    = "0.1.1"
  wait       = false
  values = [
    file("${path.module}/meltano.values.yaml"),
    local.meltano_values
  ]
  # This is not a chart value, but just a way to trick helm_release into running every time.
  # Without this, helm_release only updates the release if the chart version (in Chart.yaml) has been updated
  set {
    name  = "timestamp"
    value = timestamp()
  }
  # depends_on = [helm_release.database_admin]
}