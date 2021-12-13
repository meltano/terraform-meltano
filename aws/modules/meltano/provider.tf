provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = var.k8_cluster_endpoint
  cluster_ca_certificate = var.k8_cluster_ca_certificate
  token                  = var.k8_cluster_token
}

provider "helm" {
  kubernetes {
    host                   = var.k8_cluster_endpoint
    cluster_ca_certificate = var.k8_cluster_ca_certificate
    token                  = var.k8_cluster_token
  }
}