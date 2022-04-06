/**
* # Meltano Infrastructure Module
*
* Terraform module to provision the base infrastructure for a Meltano data platform on AWS. This module deploys foundational resources such an EKS Kubernetes cluster, RDS Databases for Meltano, Airflow and Superset as well as other ancillaries such as ECR, EFS and Prometheus. This module with default values should be enough to host a Meltano Project deployed using the `kubernetes/modules/meltano` module also in this repository.
*
* ## Usage
*
* We highly recommend pinning your module source to a specific git Tag, to ensure your infrastructure remains stable over time. The full list of available Tags is [here](https://gitlab.com/meltano/infra/terraform/-/tags). E.g.
*
* ```hcl
* module "infrastructure" {
*   # source pinned to Tag v0.1.0
*   source = "git::https://gitlab.com/meltano/infra/terraform.git//aws/modules/infrastructure?ref=v0.1.0"
* }
* ```
*
* The above snippet will deploy an environment marked `staging` to region `us-east-1`. This (among other details) can be changed by setting the appropriate variables, listed in full below. E.g.
*
* ```hcl
* module "infrastructure" {
*   # source pinned to Tag v0.1.0
*   source = "git::https://gitlab.com/meltano/infra/terraform.git//aws/modules/infrastructure?ref=v0.1.0"
*   region = "eu-west-1"
*   environment = "prod"
*
*   # override default VPC details
*   vpc = {
*     cidr = "10.1.0.0/16"
*   }
*
*   # override default RDS details
*   rds = {
*       meltano_database = {
*         instance_class = "db.t4g.small"
*       }
*       airflow_database = {
*         allocated_storage = 20
*       }
*   }
* }
* ```
*/

resource "random_string" "suffix" {
  length  = 8
  special = false
}