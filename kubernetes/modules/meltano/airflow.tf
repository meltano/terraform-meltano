
locals {
  airflow_values = <<EOT
fernetKey: ${var.airflow_fernet_key}
webserverSecretKey: ${var.airflow_webserver_secret_key}

extraEnv:
- name: AWS_REGION
  value: ${var.aws_region}
- name: AWS_DEFAULT_REGION
  value: ${var.aws_region}
- name: MELTANO_PROJECT_ROOT
  value: ${var.airflow_meltano_project_root}

images:
  airflow:
    repository: ${var.airflow_image_repository_url}
    tag: ${var.airflow_image_tag}
  pod_template:
    repository: ${var.airflow_image_repository_url}
    tag: ${var.airflow_image_tag}

data:
  metadataConnection:
    host: ${var.airflow_db_host}
    user: ${var.airflow_db_user}
    pass: ${var.airflow_db_password}
    db: ${var.airflow_db_database}
    port: ${var.airflow_db_port}
    protocol: ${var.airflow_db_protocol}

extraSecrets:
  meltano-database-uri:
    data: |
      uri: "${base64encode(var.meltano_db_uri)}"
  meltano-env-file:
    data: |
      file: "${base64encode(var.meltano_env_file)}"

secret:
- envName: MELTANO_DATABASE_URI
  secretName: meltano-database-uri
  secretKey: uri

workers:
  extraVolumes:
  - name: meltano-env-file
    secret:
      secretName: meltano-env-file
      items:
        key: file
        path: ".env"
  extraVolumeMounts:
  - name: meltano-env-file
    mountPath: "${var.airflow_meltano_project_root}/.env"
    subPath: ".env"
    readOnly: true

logs:
  persistence:
    enabled: true
    existingClaim: ${var.airflow_logs_pvc_claim_name}
EOT
}

resource "helm_release" "airflow" {
  name        = "airflow"
  namespace   = var.kubernetes_namespace
  repository  = "https://airflow.apache.org"
  chart       = "airflow"
  version     = "1.3.0"
  max_history = 10
  wait        = false
  values      = [
    file("${path.module}/airflow.values.yaml"),
    local.airflow_values
  ]
  # This is not a chart value, but just a way to trick helm_release into running every time.
  # Without this, helm_release only updates the release if the chart version (in Chart.yaml) has been updated.
  set {
    name  = "timestamp"
    value = timestamp()
  }
}
