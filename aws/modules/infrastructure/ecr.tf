module "ecr_airflow" {
  source               = "cloudposse/ecr/aws"
  version              = "0.32.3"
  namespace            = "m5o"
  stage                = "prod"
  name                 = "airflow"
  image_tag_mutability = "MUTABLE" # for "latest"
  principals_full_access = [
    module.eks.cluster_iam_role_arn,
    module.eks.worker_iam_role_arn
  ]
}

module "ecr_meltano" {
  source               = "cloudposse/ecr/aws"
  version              = "0.32.3"
  namespace            = "m5o"
  stage                = "prod"
  name                 = "meltano"
  image_tag_mutability = "MUTABLE" # for "latest"
  principals_full_access = [
    module.eks.cluster_iam_role_arn,
    module.eks.worker_iam_role_arn
  ]
}

locals {
  airflow_registry = {
    registry_id        = module.ecr_airflow.registry_id
    repository_arn     = module.ecr_airflow.repository_arn
    repository_arn_map = module.ecr_airflow.repository_arn_map
    repository_name    = module.ecr_airflow.repository_name
    repository_url     = module.ecr_airflow.repository_url
    repository_url_map = module.ecr_airflow.repository_url_map
  }
  meltano_registry = {
    registry_id        = module.ecr_meltano.registry_id
    repository_arn     = module.ecr_meltano.repository_arn
    repository_arn_map = module.ecr_meltano.repository_arn_map
    repository_name    = module.ecr_meltano.repository_name
    repository_url     = module.ecr_meltano.repository_url
    repository_url_map = module.ecr_meltano.repository_url_map
  }
}