
module "eks_worker_additional_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name        = "eks_worker_additional_security_group"
  description = "Security group for Meltano platform EKS Workers"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.private_subnets
  egress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.db_security_group.security_group_id
    }
  ]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.23.0"

  cluster_name    = local.name
  cluster_version = local.cluster_version

  vpc_id  = module.vpc.vpc_id
  subnets = concat(module.vpc.public_subnets, module.vpc.private_subnets)

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  worker_groups = [
    {
      instance_type                 = "t3.small"
      asg_max_size                  = 5
      asg_desired_capacity          = 2
      additional_security_group_ids = [module.eks_worker_additional_security_group.security_group_id]
      subnets                       = module.vpc.private_subnets
    }
  ]
  # additional IAM policies attached to worker nodes
  workers_additional_policies = []

  manage_aws_auth = true
  enable_irsa     = true

  tags = {
    GitlabRepo = "squared"
    GitlabOrg  = "meltano"
  }
}

resource "kubernetes_namespace" "meltano" {
  metadata {
    name = "meltano"
  }
  depends_on = [module.eks]
}

module "eks_efs_csi_driver" {
  source  = "DNXLabs/eks-efs-csi-driver/aws"
  version = "0.1.4"

  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  create_namespace                 = false
  create_storage_class             = false

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "aws_efs_pvc" {
  name  = "aws-efs-pvc"
  chart = "${path.module}/aws-efs-pvc"

  set {
    name  = "efs_id"
    value = module.efs.id
  }

  depends_on = [
    module.efs, module.eks_efs_csi_driver
  ]
}

locals {
  kubernetes_cluster = {
    namespace                                        = var.kubernetes_namespace
    cloudwatch_log_group_arn                         = module.eks.cloudwatch_log_group_arn
    cloudwatch_log_group_name                        = module.eks.cloudwatch_log_group_name
    cluster_arn                                      = module.eks.cluster_arn
    cluster_certificate_authority_data               = module.eks.cluster_certificate_authority_data
    cluster_endpoint                                 = module.eks.cluster_endpoint
    cluster_iam_role_arn                             = module.eks.cluster_iam_role_arn
    cluster_iam_role_name                            = module.eks.cluster_iam_role_name
    cluster_id                                       = module.eks.cluster_id
    cluster_oidc_issuer_url                          = module.eks.cluster_oidc_issuer_url
    cluster_primary_security_group_id                = module.eks.cluster_primary_security_group_id
    cluster_security_group_id                        = module.eks.cluster_security_group_id
    cluster_version                                  = module.eks.cluster_version
    config_map_aws_auth                              = module.eks.config_map_aws_auth
    fargate_iam_role_arn                             = module.eks.fargate_iam_role_arn
    fargate_iam_role_name                            = module.eks.fargate_iam_role_name
    fargate_profile_arns                             = module.eks.fargate_profile_arns
    fargate_profile_ids                              = module.eks.fargate_profile_ids
    kubeconfig                                       = module.eks.kubeconfig
    kubeconfig_filename                              = module.eks.kubeconfig_filename
    node_groups                                      = module.eks.node_groups
    oidc_provider_arn                                = module.eks.oidc_provider_arn
    security_group_rule_cluster_https_worker_ingress = module.eks.security_group_rule_cluster_https_worker_ingress
    worker_iam_instance_profile_arns                 = module.eks.worker_iam_instance_profile_arns
    worker_iam_instance_profile_names                = module.eks.worker_iam_instance_profile_names
    worker_iam_role_arn                              = module.eks.worker_iam_role_arn
    worker_iam_role_name                             = module.eks.worker_iam_role_name
    worker_security_group_id                         = module.eks.worker_security_group_id
    workers_asg_arns                                 = module.eks.workers_asg_arns
    workers_asg_names                                = module.eks.workers_asg_names
    workers_default_ami_id                           = module.eks.workers_default_ami_id
    workers_default_ami_id_windows                   = module.eks.workers_default_ami_id_windows
    workers_launch_template_arns                     = module.eks.workers_launch_template_arns
    workers_launch_template_ids                      = module.eks.workers_launch_template_ids
    workers_launch_template_latest_versions          = module.eks.workers_launch_template_latest_versions
    workers_user_data                                = module.eks.workers_user_data
    storage = {
      logs_storage_claim_name = "efs-claim"
    }
  }
}