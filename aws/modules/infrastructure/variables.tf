
variable "aws_region" {
  description = "AWS region to deploy to."
  default     = "us-east-1"
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for Meltano and Airflow."
  default     = "meltano"
}

variable "enable_vpn_gateway" {
  description = "Create a new VPN Gateway resource and attach it to the VPC?"
  default     = false
  type        = bool
}