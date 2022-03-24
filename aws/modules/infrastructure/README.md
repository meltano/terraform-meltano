# Meltano Infrastructure Module

Terraform module to provision the base infrastructure for a Meltano data platform based on AWS. This module deploys foundational resources such an EKS Kubernetes cluster, RDS Databases for Meltano, Airflow and Superset as well as other ancillaries such as ECR, EFS and Prometheus. This module with default values should be enough to host a Meltano Project deployed using the `kubernetes/modules/meltano` module also in this repository.

## Usage

We highly recommend pinning your module source to a specific git Tag, to ensure your infrastructure remains stable over time. The full list of available Tags is [here](https://gitlab.com/meltano/infra/terraform/-/tags). E.g.

```hcl
module "infrastructure" {
  # source pinned to Tag v0.1.0
  source = "git::https://gitlab.com/meltano/infra/terraform.git//aws/modules/infrastructure?ref=v0.1.0"
  ...
}
```

### Create


### Destroy


## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.0.5 |


## Providers

| Name | Version |
|------|---------|
| hashicorp/aws | 3.65.0 |
| hashicorp/kubernetes | 2.6.1 |
| hashicorp/helm | 2.4.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| ecr_airflow | cloudposse/ecr/aws | 0.32.3 |
| ecr_meltano | cloudposse/ecr/aws | 0.32.3 |
| efs | cloudposse/efs/aws | 0.32.2 |
| eks_worker_additional_security_group | terraform-aws-modules/security-group/aws | 4.7.0 |
| eks | terraform-aws-modules/eks/aws | 17.23.0 |
| eks_efs_csi_driver | DNXLabs/eks-efs-csi-driver/aws | 0.1.4 |
| alb_ingress_controller | iplabs/alb-ingress-controller/kubernetes | 3.4.0 |
| db_security_group | terraform-aws-modules/security-group/aws | 4.7.0 |
| db | terraform-aws-modules/rds/aws | ~> 3.0 |
| airflow_db | terraform-aws-modules/rds/aws | ~> 3.0 |
| superset_db | terraform-aws-modules/rds/aws | ~> 3.0 |
| vpc | terraform-aws-modules/vpc/aw | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| aws_efs_file_system_policy.efs_policy | resource |
| kubernetes_namespace.namespace | resource |
| helm_release.aws_efs_pvc | resource |
| kubernetes_namespace.prometheus | resource |
| helm_release.prometheus | resource |
| aws_availability_zones.available | data |
| random_string.suffix | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region to deploy to. | `string` | us-east-1 | no |
| environment | Meltano Environment name. | `string` | staging | no |
| vpc | Variable map for VPC creation. | `map` | <pre>{<br>    cidr            = "10.0.0.0/16"<br>    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]<br>    public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]<br>}</pre> | no |
| eks | Variable map for EKS Cluster creation. | `map` | <pre>{<br>    cluster_version                   = "1.21"<br>    cluster_tags                      = {}<br>    worker_group_instance_type        = "t3.medium"<br>    worker_group_asg_max_size         = 8<br>    worker_group_asg_desired_capacity = 6<br>    namespace_name                    = "meltano"<br>}</pre> | no |
| rds | Variable map for RDS database creation. | `map` | <pre>{<br>    meltano_database = {<br>      port                = 5432<br>      instance_class      = "db.t4g.micro"<br>      allocated_storage   = 10<br>      maintenance_window  = "Sun:00:00-Sun:03:00"<br>      backup_window       = "03:00-06:00"<br>      tags                = {}<br>      deletion_protection = true<br>    }<br>    airflow_database = {<br>      port                = 5432<br>      instance_class      = "db.t4g.micro"<br>      allocated_storage   = 10<br>      maintenance_window  = "Sun:00:00-Sun:03:00"<br>      backup_window       = "03:00-06:00"<br>      tags                = {}<br>      deletion_protection = true<br>    }<br>    superset_database = {<br>      port                = 5432<br>      instance_class      = "db.t4g.micro"<br>      allocated_storage   = 10<br>      maintenance_window  = "Sun:00:00-Sun:03:00"<br>      backup_window       = "03:00-06:00"<br>      tags                = {}<br>      deletion_protection = true<br>    }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_region | AWS region deployed to. |
| kubernetes_cluster | Map of created EKS cluster outputs. |
| meltano_database | Map of created RDS database outputs for use by Meltano. |
| airflow_database | Map of created RDS database outputs for use by Airflow. |
| superset_database | Map of created RDS database outputs for use by Superset. |
| meltano_registry | Map of created ECR registry outputs for use by Meltano. |
| airflow_registry | Map of created ECR registry outputs for use by Airflow. |
| vpc | Map of created VPC outputs. |
