<!-- BEGIN_TF_DOCS -->
# Meltano Project Module

Terraform module to deploy a containerised Meltano Project onto infrastructure provisioned by the `aws/modules/infrastructure` module in this repository. Included are Helm deployments of Meltano (the Meltano UI), Airflow and Superset.

In all three cases, external Helm charts are used:

| Chart | Version | Repository |
| ----- | ------- | ---------- |
| airflow | 1.3.0 | https://airflow.apache.org |
| meltano | 0.3.0 | https://meltano.gitlab.io/infra/helm-meltano/meltano-ui |
| superset | 0.5.3 | https://apache.github.io/superset |

## Usage

We highly recommend pinning your module source to a specific git Tag, to ensure your infrastructure remains stable over time. The full list of available Tags is [here](https://gitlab.com/meltano/infra/terraform/-/tags). E.g.

```hcl
module "infrastructure" {
  # source pinned to Tag v0.1.0
  source = "git::https://gitlab.com/meltano/infra/terraform.git//kubernetes/modules/meltano?ref=v0.1.0"
  ...
}
```

As this module is designed to work with the `aws/modules/infrastructure` module also in this repository, many of the required inputs can be captured from the outputs of that module.
For our own usage, we store the output values from `aws/modules/infrastructure` in JSON form to AWS SSM Parameter Store, allowing us to retrieve them as `data` and input them as follows:

```hcl
data "aws_ssm_parameter" "inventory" {
  name = "/prod/meltano/inventory"
}

locals {
  inventory = jsondecode(data.aws_ssm_parameter.inventory.value)
}

module "meltano" {
  source = "git::https://gitlab.com/meltano/infra/terraform.git//kubernetes/modules/meltano?ref=v0.1.0"
  # aws
  aws_region = local.inventory.aws.region
  # airflow
  airflow_fernet_key           = data.aws_ssm_parameter.airflow_fernet_key.value
  airflow_image_repository_url = local.inventory.airflow_registry.repository_url
  airflow_image_tag            = var.airflow_image_tag
  airflow_logs_pvc_claim_name  = local.inventory.kubernetes_cluster.storage.logs_storage_claim_name
  airflow_meltano_project_root = "/opt/airflow/meltano"
  airflow_webserver_secret_key = data.aws_ssm_parameter.airflow_webserver_secret.value
  # airflow database
  airflow_db_database = local.inventory.airflow_database.database
  airflow_db_host     = local.inventory.airflow_database.host
  airflow_db_password = local.inventory.airflow_database.password
  airflow_db_port     = local.inventory.airflow_database.port
  airflow_db_protocol = local.inventory.airflow_database.protocol
  airflow_db_user     = local.inventory.airflow_database.user
  airflow_db_uri      = local.inventory.airflow_database.url
  # k8 cluster
  kubernetes_cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  kubernetes_cluster_endpoint       = data.aws_eks_cluster.eks.endpoint
  kubernetes_cluster_token          = data.aws_eks_cluster_auth.eks.token
  kubernetes_namespace              = local.inventory.kubernetes_cluster.namespace
  # meltano
  meltano_db_uri               = "${local.inventory.meltano_database.url}?sslmode=disable"
  meltano_image_repository_url = local.inventory.meltano_registry.repository_url
  meltano_image_tag            = var.meltano_image_tag
  meltano_env_file             = data.aws_ssm_parameter.meltano_env_file.value
  # superset
  superset_db_host        = local.inventory.superset_database.host
  superset_db_user        = local.inventory.superset_database.user
  superset_db_password    = local.inventory.superset_database.password
  superset_db_database    = local.inventory.superset_database.database
  superset_db_port        = local.inventory.superset_database.port
  superset_admin_password = random_password.superset_password.result
  superset_dependencies   = "PyAthenaJDBC>1.0.9 PyAthena>1.2.0 'snowflake-sqlalchemy<=1.2.4'"
  superset_webserver_host = "internal-095a2699-meltano-superset-608a-2127736714.us-east-1.elb.amazonaws.com"
}
```

The full example use can be found in our [Squared](https://gitlab.com/meltano/squared/-/tree/master/deploy) project repository 🚀

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.6.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.airflow](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.meltano](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.superset](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airflow_db_database"></a> [airflow\_db\_database](#input\_airflow\_db\_database) | Airflow database name. | `string` | `"airflow"` | no |
| <a name="input_airflow_db_host"></a> [airflow\_db\_host](#input\_airflow\_db\_host) | Airflow database host. | `string` | n/a | yes |
| <a name="input_airflow_db_password"></a> [airflow\_db\_password](#input\_airflow\_db\_password) | Airflow database password. | `string` | n/a | yes |
| <a name="input_airflow_db_port"></a> [airflow\_db\_port](#input\_airflow\_db\_port) | Airflow database port. | `string` | `"5432"` | no |
| <a name="input_airflow_db_protocol"></a> [airflow\_db\_protocol](#input\_airflow\_db\_protocol) | Airflow database protocol. | `string` | `"postgresql"` | no |
| <a name="input_airflow_db_uri"></a> [airflow\_db\_uri](#input\_airflow\_db\_uri) | Airflow database connection string. | `string` | n/a | yes |
| <a name="input_airflow_db_user"></a> [airflow\_db\_user](#input\_airflow\_db\_user) | Airflow database username. | `string` | `"airflow"` | no |
| <a name="input_airflow_fernet_key"></a> [airflow\_fernet\_key](#input\_airflow\_fernet\_key) | Airflow Fernet key. | `string` | n/a | yes |
| <a name="input_airflow_image_repository_url"></a> [airflow\_image\_repository\_url](#input\_airflow\_image\_repository\_url) | Airflow container image repository url. | `string` | n/a | yes |
| <a name="input_airflow_image_tag"></a> [airflow\_image\_tag](#input\_airflow\_image\_tag) | Airflow container image tag. | `string` | `"latest"` | no |
| <a name="input_airflow_logs_pvc_claim_name"></a> [airflow\_logs\_pvc\_claim\_name](#input\_airflow\_logs\_pvc\_claim\_name) | Airflow logs Persistent Volume Claim name. | `string` | `"efs-claim"` | no |
| <a name="input_airflow_meltano_project_root"></a> [airflow\_meltano\_project\_root](#input\_airflow\_meltano\_project\_root) | Meltano project root in Airflow container. | `string` | `"/opt/airflow/meltano"` | no |
| <a name="input_airflow_webserver_secret_key"></a> [airflow\_webserver\_secret\_key](#input\_airflow\_webserver\_secret\_key) | Airflow webserver secret key. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region to deploy to. | `string` | `"us-east-1"` | no |
| <a name="input_kubernetes_cluster_ca_certificate"></a> [kubernetes\_cluster\_ca\_certificate](#input\_kubernetes\_cluster\_ca\_certificate) | Kubernetes cluster CA certificate (base64 encoded). | `string` | n/a | yes |
| <a name="input_kubernetes_cluster_endpoint"></a> [kubernetes\_cluster\_endpoint](#input\_kubernetes\_cluster\_endpoint) | Kubernetes cluster endpoint. | `string` | n/a | yes |
| <a name="input_kubernetes_cluster_token"></a> [kubernetes\_cluster\_token](#input\_kubernetes\_cluster\_token) | Kubernetes cluster auth token. | `string` | n/a | yes |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace for Meltano, Airflow and Superset. | `string` | `"meltano"` | no |
| <a name="input_meltano_db_uri"></a> [meltano\_db\_uri](#input\_meltano\_db\_uri) | Meltano database uri. | `string` | n/a | yes |
| <a name="input_meltano_env_file"></a> [meltano\_env\_file](#input\_meltano\_env\_file) | Meltano .env file contents. | `string` | `""` | no |
| <a name="input_meltano_image_repository_url"></a> [meltano\_image\_repository\_url](#input\_meltano\_image\_repository\_url) | Meltano container image repository url. | `string` | n/a | yes |
| <a name="input_meltano_image_tag"></a> [meltano\_image\_tag](#input\_meltano\_image\_tag) | Meltano container image tag. | `string` | `"latest"` | no |
| <a name="input_superset_admin_password"></a> [superset\_admin\_password](#input\_superset\_admin\_password) | Superset admin password. | `string` | n/a | yes |
| <a name="input_superset_db_database"></a> [superset\_db\_database](#input\_superset\_db\_database) | Superset database name. | `string` | `"superset"` | no |
| <a name="input_superset_db_host"></a> [superset\_db\_host](#input\_superset\_db\_host) | Superset database host. | `string` | n/a | yes |
| <a name="input_superset_db_password"></a> [superset\_db\_password](#input\_superset\_db\_password) | Superset database password. | `string` | n/a | yes |
| <a name="input_superset_db_port"></a> [superset\_db\_port](#input\_superset\_db\_port) | Superset database port. | `string` | `"5432"` | no |
| <a name="input_superset_db_user"></a> [superset\_db\_user](#input\_superset\_db\_user) | Superset database username. | `string` | `"superset"` | no |
| <a name="input_superset_dependencies"></a> [superset\_dependencies](#input\_superset\_dependencies) | Superset python dependencies to install. | `string` | n/a | yes |
| <a name="input_superset_webserver_host"></a> [superset\_webserver\_host](#input\_superset\_webserver\_host) | Superset webserver host for ingress. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->