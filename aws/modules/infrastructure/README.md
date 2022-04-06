<!-- BEGIN_TF_DOCS -->
# Meltano Infrastructure Module

Terraform module to provision the base infrastructure for a Meltano data platform on AWS. This module deploys foundational resources such an EKS Kubernetes cluster, RDS Databases for Meltano, Airflow and Superset as well as other ancillaries such as ECR, EFS and Prometheus. This module with default values should be enough to host a Meltano Project deployed using the `kubernetes/modules/meltano` module also in this repository.

## Usage

We highly recommend pinning your module source to a specific git Tag, to ensure your infrastructure remains stable over time. The full list of available Tags is [here](https://gitlab.com/meltano/infra/terraform/-/tags). E.g.

```hcl
module "infrastructure" {
  # source pinned to Tag v0.1.0
  source = "git::https://gitlab.com/meltano/infra/terraform.git//aws/modules/infrastructure?ref=v0.1.0"
}
```

The above snippet will deploy an environment marked `staging` to region `us-east-1`. This (among other details) can be changed by setting the appropriate variables, listed in full below. E.g.

```hcl
module "infrastructure" {
  # source pinned to Tag v0.1.0
  source = "git::https://gitlab.com/meltano/infra/terraform.git//aws/modules/infrastructure?ref=v0.1.0"
  region = "eu-west-1"
  environment = "prod"

  # override default VPC details
  vpc = {
    cidr = "10.1.0.0/16"
  }

  # override default RDS details
  rds = {
      meltano_database = {
        instance_class = "db.t4g.small"
      }
      airflow_database = {
        allocated_storage = 20
      }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.65.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.6.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.65.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.6.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_airflow_db"></a> [airflow\_db](#module\_airflow\_db) | terraform-aws-modules/rds/aws | ~> 3.0 |
| <a name="module_alb_ingress_controller"></a> [alb\_ingress\_controller](#module\_alb\_ingress\_controller) | iplabs/alb-ingress-controller/kubernetes | 3.4.0 |
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | ~> 3.0 |
| <a name="module_db_security_group"></a> [db\_security\_group](#module\_db\_security\_group) | terraform-aws-modules/security-group/aws | 4.7.0 |
| <a name="module_ecr_airflow"></a> [ecr\_airflow](#module\_ecr\_airflow) | cloudposse/ecr/aws | 0.32.3 |
| <a name="module_ecr_meltano"></a> [ecr\_meltano](#module\_ecr\_meltano) | cloudposse/ecr/aws | 0.32.3 |
| <a name="module_efs"></a> [efs](#module\_efs) | cloudposse/efs/aws | 0.32.2 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 17.23.0 |
| <a name="module_eks_efs_csi_driver"></a> [eks\_efs\_csi\_driver](#module\_eks\_efs\_csi\_driver) | DNXLabs/eks-efs-csi-driver/aws | 0.1.4 |
| <a name="module_eks_worker_additional_security_group"></a> [eks\_worker\_additional\_security\_group](#module\_eks\_worker\_additional\_security\_group) | terraform-aws-modules/security-group/aws | 4.7.0 |
| <a name="module_superset_db"></a> [superset\_db](#module\_superset\_db) | terraform-aws-modules/rds/aws | ~> 3.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system_policy.efs_policy](https://registry.terraform.io/providers/hashicorp/aws/3.65.0/docs/resources/efs_file_system_policy) | resource |
| [helm_release.aws_efs_pvc](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [kubernetes_namespace.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/namespace) | resource |
| [kubernetes_namespace.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/namespace) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/3.65.0/docs/data-sources/availability_zones) | data source |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/3.65.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.eks](https://registry.terraform.io/providers/hashicorp/aws/3.65.0/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy to. | `string` | `"us-east-1"` | no |
| <a name="input_eks_cluster_tags"></a> [eks\_cluster\_tags](#input\_eks\_cluster\_tags) | EKS cluster tags. | `map(string)` | `{}` | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | EKS cluster version. | `string` | `"1.21"` | no |
| <a name="input_eks_namespace_name"></a> [eks\_namespace\_name](#input\_eks\_namespace\_name) | EKS namespace to create. | `string` | `"meltano"` | no |
| <a name="input_eks_worker_group_asg_desired_capacity"></a> [eks\_worker\_group\_asg\_desired\_capacity](#input\_eks\_worker\_group\_asg\_desired\_capacity) | EKS worker group asg desired capacity. | `number` | `6` | no |
| <a name="input_eks_worker_group_asg_max_size"></a> [eks\_worker\_group\_asg\_max\_size](#input\_eks\_worker\_group\_asg\_max\_size) | EKS worker group asg max size. | `number` | `8` | no |
| <a name="input_eks_worker_group_instance_type"></a> [eks\_worker\_group\_instance\_type](#input\_eks\_worker\_group\_instance\_type) | EKS worker group instance type. | `string` | `"t3.medium"` | no |
| <a name="input_meltano_environment"></a> [meltano\_environment](#input\_meltano\_environment) | Meltano Environment name. | `string` | `"staging"` | no |
| <a name="input_rds_airflow_database_allocated_storage"></a> [rds\_airflow\_database\_allocated\_storage](#input\_rds\_airflow\_database\_allocated\_storage) | RDS Airflow database allocated storage. | `number` | `10` | no |
| <a name="input_rds_airflow_database_instance_class"></a> [rds\_airflow\_database\_instance\_class](#input\_rds\_airflow\_database\_instance\_class) | RDS Airflow database instance class. | `string` | `"db.t4g.micro"` | no |
| <a name="input_rds_airflow_database_port"></a> [rds\_airflow\_database\_port](#input\_rds\_airflow\_database\_port) | RDS Airflow database port. | `number` | `5432` | no |
| <a name="input_rds_backup_window"></a> [rds\_backup\_window](#input\_rds\_backup\_window) | RDS backup window (applied to all databases). | `string` | `"03:00-06:00"` | no |
| <a name="input_rds_deletion_protection"></a> [rds\_deletion\_protection](#input\_rds\_deletion\_protection) | RDS deletion protection (applied to all databases). | `bool` | `true` | no |
| <a name="input_rds_maintenance_window"></a> [rds\_maintenance\_window](#input\_rds\_maintenance\_window) | RDS maintenance window (applied to all databases). | `string` | `"Sun:00:00-Sun:03:00"` | no |
| <a name="input_rds_meltano_database_allocated_storage"></a> [rds\_meltano\_database\_allocated\_storage](#input\_rds\_meltano\_database\_allocated\_storage) | RDS Meltano database allocated storage. | `number` | `10` | no |
| <a name="input_rds_meltano_database_instance_class"></a> [rds\_meltano\_database\_instance\_class](#input\_rds\_meltano\_database\_instance\_class) | RDS Meltano database instance class. | `string` | `"db.t4g.micro"` | no |
| <a name="input_rds_meltano_database_port"></a> [rds\_meltano\_database\_port](#input\_rds\_meltano\_database\_port) | RDS Meltano database port. | `number` | `5432` | no |
| <a name="input_rds_superset_database_allocated_storage"></a> [rds\_superset\_database\_allocated\_storage](#input\_rds\_superset\_database\_allocated\_storage) | RDS Superset database allocated storage. | `number` | `10` | no |
| <a name="input_rds_superset_database_instance_class"></a> [rds\_superset\_database\_instance\_class](#input\_rds\_superset\_database\_instance\_class) | RDS Superset database instance class. | `string` | `"db.t4g.micro"` | no |
| <a name="input_rds_superset_database_port"></a> [rds\_superset\_database\_port](#input\_rds\_superset\_database\_port) | RDS Superset database port. | `number` | `5432` | no |
| <a name="input_rds_tags"></a> [rds\_tags](#input\_rds\_tags) | RDS tags (applied to all databases). | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR block. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | VPC private subnets to create. | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | VPC public subnets to create. | `list(string)` | <pre>[<br>  "10.0.4.0/24",<br>  "10.0.5.0/24",<br>  "10.0.6.0/24"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_airflow_database"></a> [airflow\_database](#output\_airflow\_database) | Map of created RDS database outputs for use by Airflow. |
| <a name="output_airflow_registry"></a> [airflow\_registry](#output\_airflow\_registry) | Map of created ECR registry outputs for use by Airflow. |
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS region deployed to. |
| <a name="output_kubernetes_cluster"></a> [kubernetes\_cluster](#output\_kubernetes\_cluster) | Map of created EKS cluster outputs. |
| <a name="output_meltano_database"></a> [meltano\_database](#output\_meltano\_database) | Map of created RDS database outputs for use by Meltano. |
| <a name="output_meltano_registry"></a> [meltano\_registry](#output\_meltano\_registry) | Map of created ECR registry outputs for use by Meltano. |
| <a name="output_superset_database"></a> [superset\_database](#output\_superset\_database) | Map of created RDS database outputs for use by Meltano. |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | Map of created VPC outputs. |
<!-- END_TF_DOCS -->