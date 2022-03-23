
variable "aws_region" {
  description = "AWS region to deploy to."
  default     = "us-east-1"
}

variable "environment" {
  description = "Meltano Environment name."
  default     = "staging"
}

variable "vpc" {
  description = "Variable map for VPC creation."
  default = {
    cidr            = "10.0.0.0/16"
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }
}

variable "eks" {
  description = "Variable map for EKS Cluster creation."
  default = {
    cluster_version                   = "1.21"
    cluster_tags                      = {}
    worker_group_instance_type        = "t3.medium"
    worker_group_asg_max_size         = 8
    worker_group_asg_desired_capacity = 6
    namespace_name                    = "meltano"
  }
}

variable "rds" {
  description = "Variable map for RDS database creation."
  default = {
    meltano_database = {
      port                = 5432
      instance_class      = "db.t4g.micro"
      allocated_storage   = 10
      maintenance_window  = "Sun:00:00-Sun:03:00"
      backup_window       = "03:00-06:00"
      tags                = {}
      deletion_protection = true
    }

    airflow_database = {
      port                = 5432
      instance_class      = "db.t4g.micro"
      allocated_storage   = 10
      maintenance_window  = "Sun:00:00-Sun:03:00"
      backup_window       = "03:00-06:00"
      tags                = {}
      deletion_protection = true
    }

    superset_database = {
      port                = 5432
      instance_class      = "db.t4g.micro"
      allocated_storage   = 10
      maintenance_window  = "Sun:00:00-Sun:03:00"
      backup_window       = "03:00-06:00"
      tags                = {}
      deletion_protection = true
    }
  }
}