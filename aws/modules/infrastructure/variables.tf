
variable "aws_region" {
  description = "AWS region to deploy to."
  default     = "us-east-1"
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for Meltano and Airflow."
  default     = "meltano"
}
