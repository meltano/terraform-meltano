
module "db_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name        = "meltano_${var.meltano_environment}_db_security_group"
  description = "${var.meltano_environment} security group for Meltano platform RDS database"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.eks.worker_security_group_id
    }
  ]
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "meltanodb-${var.meltano_environment}"

  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = var.rds_meltano_database_instance_class
  allocated_storage = var.rds_meltano_database_allocated_storage

  name                                = "meltano"
  username                            = "meltano"
  port                                = var.rds_meltano_database_port
  create_random_password              = true
  iam_database_authentication_enabled = false

  vpc_security_group_ids = [module.db_security_group.security_group_id]

  maintenance_window = var.rds_maintenance_window
  backup_window      = var.rds_backup_window

  # Enhanced Monitoring
  create_monitoring_role = false

  tags = var.rds_tags

  # DB subnet group
  subnet_ids = module.vpc.private_subnets

  # DB parameter group
  family = "postgres13"

  # DB option group
  major_engine_version = "13.4"

  # Database Deletion Protection
  deletion_protection = var.rds_deletion_protection

  parameters = []

  options = []
}


module "airflow_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "airflowdb-${var.meltano_environment}"

  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = var.rds_airflow_database_instance_class
  allocated_storage = var.rds_airflow_database_allocated_storage

  name                                = "airflow"
  username                            = "airflow"
  port                                = var.rds_airflow_database_port
  create_random_password              = true
  iam_database_authentication_enabled = false

  vpc_security_group_ids = [module.db_security_group.security_group_id]

  maintenance_window = var.rds_maintenance_window
  backup_window      = var.rds_backup_window

  # Enhanced Monitoring
  create_monitoring_role = false

  tags = var.rds_tags

  # DB subnet group
  subnet_ids = module.vpc.private_subnets

  # DB parameter group
  family = "postgres13"

  # DB option group
  major_engine_version = "13.4"

  # Database Deletion Protection
  deletion_protection = var.rds_deletion_protection

  parameters = []

  options = []
}


module "superset_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "supersetdb-${var.meltano_environment}"

  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = var.rds_superset_database_instance_class
  allocated_storage = var.rds_superset_database_allocated_storage

  name                                = "superset"
  username                            = "superset"
  port                                = var.rds_superset_database_port
  create_random_password              = true
  iam_database_authentication_enabled = false

  vpc_security_group_ids = [module.db_security_group.security_group_id]

  maintenance_window = var.rds_maintenance_window
  backup_window      = var.rds_backup_window

  # Enhanced Monitoring
  create_monitoring_role = false

  tags = var.rds_tags

  # DB subnet group
  subnet_ids = module.vpc.private_subnets

  # DB parameter group
  family = "postgres13"

  # DB option group
  major_engine_version = "13.4"

  # Database Deletion Protection
  deletion_protection = var.rds_deletion_protection

  parameters = []

  options = []
}

locals {
  airflow_database = {
    host     = module.airflow_db.db_instance_address
    port     = module.airflow_db.db_instance_port
    user     = module.airflow_db.db_instance_username
    password = module.airflow_db.db_instance_password
    database = module.airflow_db.db_instance_name
    protocol = "postgresql"
    url      = "postgresql://${module.airflow_db.db_instance_username}:${module.airflow_db.db_instance_password}@${module.airflow_db.db_instance_endpoint}/${module.airflow_db.db_instance_name}"
  }
  meltano_database = {
    host     = module.db.db_instance_endpoint
    port     = module.db.db_instance_port
    user     = module.db.db_instance_username
    password = module.db.db_instance_password
    database = module.db.db_instance_name
    protocol = "postgresql"
    url      = "postgresql://${module.db.db_instance_username}:${module.db.db_instance_password}@${module.db.db_instance_endpoint}/${module.db.db_instance_name}"
  }
  superset_database = {
    host     = module.superset_db.db_instance_address
    port     = module.superset_db.db_instance_port
    user     = module.superset_db.db_instance_username
    password = module.superset_db.db_instance_password
    database = module.superset_db.db_instance_name
    protocol = "postgresql"
    url      = "postgresql://${module.superset_db.db_instance_username}:${module.superset_db.db_instance_password}@${module.superset_db.db_instance_endpoint}/${module.superset_db.db_instance_name}"
  }
}
