
module "db_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name        = "meltano_db_security_group"
  description = "Security group for Meltano platform RDS database"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.vpc.cidr]
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

  identifier = "meltanodb"

  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = var.rds.meltano_database.instance_class
  allocated_storage = var.rds.meltano_database.allocated_storage

  name                                = "meltano"
  username                            = "meltano"
  port                                = var.rds.meltano_database.port
  create_random_password              = true
  iam_database_authentication_enabled = false

  vpc_security_group_ids = [module.db_security_group.security_group_id]

  maintenance_window = var.rds.meltano_database.maintenance_window
  backup_window      = var.rds.meltano_database.backup_window

  # Enhanced Monitoring
  create_monitoring_role = false

  tags = var.rds.meltano_database.tags

  # DB subnet group
  subnet_ids = module.vpc.private_subnets

  # DB parameter group
  family = "postgres13"

  # DB option group
  major_engine_version = "13.4"

  # Database Deletion Protection
  deletion_protection = var.rds.meltano_database.deletion_protection

  parameters = []

  options = []
}


module "airflow_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "airflowdb"

  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = var.rds.airflow_database.instance_class
  allocated_storage = var.rds.airflow_database.allocated_storage

  name                                = "airflow"
  username                            = "airflow"
  port                                = var.rds.airflow_database.port
  create_random_password              = true
  iam_database_authentication_enabled = false

  vpc_security_group_ids = [module.db_security_group.security_group_id]

  maintenance_window = var.rds.airflow_database.maintenance_window
  backup_window      = var.rds.airflow_database.backup_window

  # Enhanced Monitoring
  create_monitoring_role = false

  tags = var.rds.airflow_database.tags

  # DB subnet group
  subnet_ids = module.vpc.private_subnets

  # DB parameter group
  family = "postgres13"

  # DB option group
  major_engine_version = "13.4"

  # Database Deletion Protection
  deletion_protection = var.rds.airflow_database.deletion_protection

  parameters = []

  options = []
}


module "superset_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "supersetdb"

  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = var.rds.superset_database.instance_class
  allocated_storage = var.rds.superset_database.allocated_storage

  name                                = "superset"
  username                            = "superset"
  port                                = var.rds.superset_database.port
  create_random_password              = true
  iam_database_authentication_enabled = false

  vpc_security_group_ids = [module.db_security_group.security_group_id]

  maintenance_window = var.rds.superset_database.maintenance_window
  backup_window      = var.rds.superset_database.backup_window

  # Enhanced Monitoring
  create_monitoring_role = false

  tags = var.rds.superset_database.tags

  # DB subnet group
  subnet_ids = module.vpc.private_subnets

  # DB parameter group
  family = "postgres13"

  # DB option group
  major_engine_version = "13.4"

  # Database Deletion Protection
  deletion_protection = var.rds.superset_database.deletion_protection

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
