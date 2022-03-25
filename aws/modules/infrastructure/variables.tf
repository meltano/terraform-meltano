
variable "aws_region" {
  description = "AWS region to deploy to."
  default     = "us-east-1"
}

variable "environment" {
  description = "Meltano Environment name."
  default     = "staging"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  default     = "10.0.0.0/16"
  type        = string
}

variable "vpc_private_subnets" {
  description = "VPC private subnets to create."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "VPC public subnets to create."
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  type        = list(string)
}

variable "eks_cluster_version" {
  description = "EKS cluster version."
  default     = "1.21"
  type        = string
}

variable "eks_cluster_tags" {
  description = "EKS cluster tags."
  default     = {}
  type        = map(string)
}

variable "eks_worker_group_instance_type" {
  description = "EKS worker group instance type."
  default     = "t3.medium"
  type        = string
}

variable "eks_worker_group_asg_max_size" {
  description = "EKS worker group asg max size."
  default     = 8
  type        = number
}

variable "eks_worker_group_asg_desired_capacity" {
  description = "EKS worker group asg desired capacity."
  default     = 6
  type        = number
}

variable "eks_namespace_name" {
  description = "EKS namespace to create."
  default     = "meltano"
  type        = string
}

variable "rds_maintenance_window" {
  description = "RDS maintenance window (applied to all databases)."
  default     = "Sun:00:00-Sun:03:00"
  type        = string
}

variable "rds_backup_window" {
  description = "RDS backup window (applied to all databases)."
  default     = "03:00-06:00"
  type        = string
}

variable "rds_tags" {
  description = "RDS tags (applied to all databases)."
  default     = {}
  type        = map(string)
}

variable "rds_deletion_protection" {
  description = "RDS deletion protection (applied to all databases)."
  default     = true
  type        = bool
}

variable "rds_meltano_database_port" {
  description = "RDS Meltano database port."
  default     = 5432
  type        = number
}

variable "rds_meltano_database_instance_class" {
  description = "RDS Meltano database instance class."
  default     = "db.t4g.micro"
  type        = string
}

variable "rds_meltano_database_allocated_storage" {
  description = "RDS Meltano database allocated storage."
  default     = 10
  type        = number
}

variable "rds_airflow_database_port" {
  description = "RDS Airflow database port."
  default     = 5432
  type        = number
}

variable "rds_airflow_database_instance_class" {
  description = "RDS Airflow database instance class."
  default     = "db.t4g.micro"
  type        = string
}

variable "rds_airflow_database_allocated_storage" {
  description = "RDS Airflow database allocated storage."
  default     = 10
  type        = number
}

variable "rds_superset_database_port" {
  description = "RDS Superset database port."
  default     = 5432
  type        = number
}

variable "rds_superset_database_instance_class" {
  description = "RDS Superset database instance class."
  default     = "db.t4g.micro"
  type        = string
}

variable "rds_superset_database_allocated_storage" {
  description = "RDS Superset database allocated storage."
  default     = 10
  type        = number
}
