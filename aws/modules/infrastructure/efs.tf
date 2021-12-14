
module "efs" {
  source    = "cloudposse/efs/aws"
  version   = "0.32.2"
  namespace = "m5o"
  stage     = "prod"
  name      = "meltano"
  region    = var.aws_region
  vpc_id    = module.vpc.vpc_id
  subnets   = module.vpc.private_subnets
  zone_id   = []
  allowed_security_group_ids = [
    module.eks.cluster_security_group_id,
    module.eks.worker_security_group_id
  ]
}

resource "aws_efs_file_system_policy" "efs-policy" {
  file_system_id                     = module.efs.id
  bypass_policy_lockout_safety_check = true
  policy                             = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "EfsFsPolicy",
    "Statement": [
        {
            "Sid": "efs-fs-policy",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${module.efs.arn}",
            "Action": [
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientWrite"
            ]
        }
    ]
}
POLICY
}
