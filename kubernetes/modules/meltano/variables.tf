variable "aws_region" {
  description = "AWS Region to deploy to."
  default     = "us-east-1"
  type        = string
}

# Provider Variables
variable "kubernetes_cluster_endpoint" {
  description = "Kubernetes cluster endpoint."
  type        = string
}

variable "kubernetes_cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate (base64 encoded)."
  type        = string
}

variable "kubernetes_cluster_token" {
  description = "Kubernetes cluster auth token."
  type        = string
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for Meltano, Airflow and Superset."
  default     = "meltano"
  type        = string
}

# Meltano Variables
variable "meltano_db_uri" {
  description = "Meltano database uri."
  type        = string
}

variable "meltano_image_repository_url" {
  description = "Meltano container image repository url."
  type        = string
}

variable "meltano_image_tag" {
  description = "Meltano container image tag."
  default     = "latest"
  type        = string
}

variable "meltano_env_file" {
  description = "Meltano .env file contents."
  default     = ""
  type        = string
}

# Airflow Variables
variable "airflow_fernet_key" {
  description = "Airflow Fernet key."
  type        = string
}

variable "airflow_webserver_secret_key" {
  description = "Airflow webserver secret key."
  type        = string
}

variable "airflow_meltano_project_root" {
  description = "Meltano project root in Airflow container."
  default     = "/opt/airflow/meltano"
  type        = string
}

variable "airflow_image_repository_url" {
  description = "Airflow container image repository url."
  type        = string
}

variable "airflow_image_tag" {
  description = "Airflow container image tag."
  default     = "latest"
  type        = string
}

variable "airflow_db_host" {
  description = "Airflow database host."
  type        = string
}

variable "airflow_db_user" {
  description = "Airflow database username."
  default     = "airflow"
  type        = string
}

variable "airflow_db_password" {
  description = "Airflow database password."
  type        = string
}

variable "airflow_db_database" {
  description = "Airflow database name."
  default     = "airflow"
  type        = string
}

variable "airflow_db_port" {
  description = "Airflow database port."
  default     = "5432"
  type        = string
}

variable "airflow_db_protocol" {
  description = "Airflow database protocol."
  default     = "postgresql"
  type        = string
}

variable "airflow_db_uri" {
  description = "Airflow database connection string."
  type        = string
}

variable "airflow_logs_pvc_claim_name" {
  description = "Airflow logs Persistent Volume Claim name."
  default     = "efs-claim"
  type        = string
}

variable "superset_db_host" {
  description = "Superset database host."
  type        = string
}

variable "superset_db_user" {
  description = "Superset database username."
  default     = "superset"
  type        = string
}

variable "superset_db_password" {
  description = "Superset database password."
  type        = string
}

variable "superset_db_database" {
  description = "Superset database name."
  default     = "superset"
  type        = string
}

variable "superset_db_port" {
  description = "Superset database port."
  default     = "5432"
  type        = string
}

variable "superset_admin_password" {
  description = "Superset admin password."
  type        = string
}

variable "superset_dependencies" {
  description = "Superset python dependencies to install."
  type        = string
}

variable "superset_webserver_host" {
  description = "Superset webserver host for ingress."
  type        = string
}