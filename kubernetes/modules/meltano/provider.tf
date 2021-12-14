provider "kubernetes" {
  host                   = var.kubernetes_cluster_endpoint
  cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
  token                  = var.kubernetes_cluster_token
}

provider "helm" {
  kubernetes {
    host                   = var.kubernetes_cluster_endpoint
    cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
    token                  = var.kubernetes_cluster_token
  }
}