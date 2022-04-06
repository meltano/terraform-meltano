/**
* # Meltano Project Module
*
* Terraform module to deploy a containerised Meltano Project onto infrastructure provisioned by the `aws/modules/infrastructure` module in this repository. Included are Helm deployments of Meltano (the Meltano UI), Airflow and Superset.
*
* In all three cases, external Helm charts are used:
*
* | Chart | Version | Repository |
* | ----- | ------- | ---------- |
* | airflow | 1.3.0 | https://airflow.apache.org |
* | meltano | 0.3.0 | https://meltano.gitlab.io/infra/helm-meltano/meltano-ui |
* | superset | 0.5.3 | https://apache.github.io/superset |
*
* ## Usage
*
* We highly recommend pinning your module source to a specific git Tag, to ensure your infrastructure remains stable over time. The full list of available Tags is [here](https://gitlab.com/meltano/infra/terraform/-/tags). E.g.
*
* ```hcl
* module "infrastructure" {
*   # source pinned to Tag v0.1.0
*   source = "git::https://gitlab.com/meltano/infra/terraform.git//kubernetes/modules/meltano?ref=v0.1.0"
*   ...
* }
* ```
*
* As this module is designed to work with the `aws/modules/infrastructure` module also in this repository, many of the required inputs can be captured from the outputs of that module.
* For our own usage, we store the output values from `aws/modules/infrastructure` in JSON form to AWS SSM Parameter Store, allowing us to retrieve them as `data` and input them as follows:
*
* ```hcl
* data "aws_ssm_parameter" "inventory" {
*   name = "/prod/meltano/inventory"
* }
*
* locals {
*   inventory = jsondecode(data.aws_ssm_parameter.inventory.value)
* }
*
* module "meltano" {
*   source = "git::https://gitlab.com/meltano/infra/terraform.git//kubernetes/modules/meltano?ref=v0.1.0"
*   # aws
*   aws_region = local.inventory.aws.region
*   # airflow
*   airflow_fernet_key           = data.aws_ssm_parameter.airflow_fernet_key.value
*   airflow_image_repository_url = local.inventory.airflow_registry.repository_url
*   airflow_image_tag            = var.airflow_image_tag
*   airflow_logs_pvc_claim_name  = local.inventory.kubernetes_cluster.storage.logs_storage_claim_name
*   airflow_meltano_project_root = "/opt/airflow/meltano"
*   airflow_webserver_secret_key = data.aws_ssm_parameter.airflow_webserver_secret.value
*   # airflow database
*   airflow_db_database = local.inventory.airflow_database.database
*   airflow_db_host     = local.inventory.airflow_database.host
*   airflow_db_password = local.inventory.airflow_database.password
*   airflow_db_port     = local.inventory.airflow_database.port
*   airflow_db_protocol = local.inventory.airflow_database.protocol
*   airflow_db_user     = local.inventory.airflow_database.user
*   airflow_db_uri      = local.inventory.airflow_database.url
*   # k8 cluster
*   kubernetes_cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
*   kubernetes_cluster_endpoint       = data.aws_eks_cluster.eks.endpoint
*   kubernetes_cluster_token          = data.aws_eks_cluster_auth.eks.token
*   kubernetes_namespace              = local.inventory.kubernetes_cluster.namespace
*   # meltano
*   meltano_db_uri               = "${local.inventory.meltano_database.url}?sslmode=disable"
*   meltano_image_repository_url = local.inventory.meltano_registry.repository_url
*   meltano_image_tag            = var.meltano_image_tag
*   meltano_env_file             = data.aws_ssm_parameter.meltano_env_file.value
*   # superset
*   superset_db_host        = local.inventory.superset_database.host
*   superset_db_user        = local.inventory.superset_database.user
*   superset_db_password    = local.inventory.superset_database.password
*   superset_db_database    = local.inventory.superset_database.database
*   superset_db_port        = local.inventory.superset_database.port
*   superset_admin_password = random_password.superset_password.result
*   superset_dependencies   = "PyAthenaJDBC>1.0.9 PyAthena>1.2.0 'snowflake-sqlalchemy<=1.2.4'"
*   superset_webserver_host = "internal-095a2699-meltano-superset-608a-2127736714.us-east-1.elb.amazonaws.com"
* }
* ```
*
* The full example use can be found in our [Squared](https://gitlab.com/meltano/squared/-/tree/master/deploy) project repository 🚀
*/

locals {
  database_admin_values = <<EOT
image:
  repository: ${var.airflow_image_repository_url}
  tag: ${var.airflow_image_tag}
  pullPolicy: Always
airflow:
  sql_alchemy_conn: ${var.airflow_db_uri}
EOT
}

# resource "helm_release" "database_admin" {
#   name       = "database-admin"
#   chart = "${path.module}/database-admin"
#   namespace  = "meltano"
#   version    = "0.1.1"
#   wait       = true
#   values = [
#     local.database_admin_values
#   ]
#   # This is not a chart value, but just a way to trick helm_release into running every time.
#   # Without this, helm_release only updates the release if the chart version (in Chart.yaml) has been updated
#   set {
#     name  = "timestamp"
#     value = timestamp()
#   }
# }