# terraform

Terraform modules to support the deployment of Meltano. As per our [blog post](https://meltano.com/blog/deploying-meltano-for-meltano), the following modules are designed to be complimentary.

We also recommend checking out our [Meltano Squared](https://gitlab.com/meltano/squared) project where we use these modules to deploy Meltano for Meltano (get it?).

## `aws/modules/infrastructure`

Terraform module to provision the base infrastructure for a Meltano data platform on AWS. This module deploys foundational resources such an EKS Kubernetes cluster, RDS Databases for Meltano, Airflow and Superset as well as other ancillaries such as ECR, EFS and Prometheus. This module with default values should be enough to host a Meltano Project deployed using the `kubernetes/modules/meltano` module also in this repository.

Full details in the modules [README.md](aws/modules/infrastructure/README.md)

## `kubernetes/modules/meltano`

Terraform module to deploy a containerised Meltano Project onto infrastructure provisioned by the `aws/modules/infrastructure` module in this repository. Included are Helm deployments of Meltano (the Meltano UI), Airflow and Superset.

In all three cases, external Helm charts are used:

| Chart | Version | Repository |
| ----- | ------- | ---------- |
| airflow | 1.3.0 | https://airflow.apache.org |
| meltano | 0.3.0 | https://meltano.gitlab.io/infra/helm-meltano/meltano-ui |
| superset | 0.5.3 | https://apache.github.io/superset |

Full details in the modules [README.md](kubernetes/modules/meltano/README.md)