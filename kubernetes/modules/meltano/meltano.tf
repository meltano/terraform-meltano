locals {
  meltano_values = {
    database_uri         = var.meltano_db_uri
    image_repository_url = var.meltano_image_repository_url
    image_tag            = var.meltano_image_tag
    b64_env_file         = base64encode(var.meltano_env_file)
  }
}

resource "helm_release" "meltano" {
  name       = "meltano"
  repository = "https://meltano.gitlab.io/infra/helm-meltano/meltano"
  chart      = "meltano"
  # chart = "../../../infrastructure/helm-meltano/meltano"
  namespace = "meltano"
  version   = "0.2.0"
  wait      = false
  values = [
    templatefile("${path.module}/meltano.values.tftpl", local.meltano_values)
  ]
  # This is not a chart value, but just a way to trick helm_release into running every time.
  # Without this, helm_release only updates the release if the chart version (in Chart.yaml) has been updated
  set {
    name  = "timestamp"
    value = timestamp()
  }
  # depends_on = [helm_release.database_admin]
}