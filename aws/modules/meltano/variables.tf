# Provider Variables
variable "aws_region" {
  description = "AWS Region"
}

variable "k8_cluster_endpoint" {
  description = "Kubernetes cluster endpoint."
}

variable "k8_cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate (base64 encoded)."
}

variable "k8_cluster_token" {
  description = "Kubernetes cluster auth token."
}

variable "k8_namespace" {
  description = "Kubernetes namespace for Meltano and Airflow."
  default = "meltano"
}

# Meltano Variables
variable "meltano_db_uri" {
  description = "Meltano database uri."
}

variable "meltano_image_repository_url" {
  description = "Meltano Docker repository url."
}

variable "meltano_image_tag" {
  description = "Meltano Docker image tag."
  default = "latest"
}

variable "meltano_env_file" {
  type = string
  description = "Meltano .env file contents."
}

# Airflow Variables
variable "airflow_fernet_key" {
  description = "Airflow Fernet key."
}

variable "airflow_webserver_secret_key" {
  description = "Airflow webserver secret key."
}

variable "airflow_meltano_project_root" {
  description = "Meltano project root in Airflow container."
  default = "/opt/airflow/meltano"
}

variable "airflow_image_repository_url" {
  description = "Airflow Docker repository url."
}

variable "airflow_image_tag" {
  description = "Airflow Docker image tag."
  default = "latest"
}

variable "airflow_db_host" {
  description = "Airflow database host."
}

variable "airflow_db_user" {
  description = "Airflow database username."
  default = "airflow"
}

variable "airflow_db_password" {
  description = "Airflow database password."
}

variable "airflow_db_database" {
  description = "Airflow database name."
  default = "airflow"
}

variable "airflow_db_port" {
  description = "Airflow database port."
  default = "5432"
}

variable "airflow_db_protocol" {
  description = "Airflow database protocol."
  default = "postgresql"
}

variable "airflow_logs_pvc_claim_name" {
  description = "Airflow logs Persistent Volume Claim name."
  default = "efs-claim"
}
