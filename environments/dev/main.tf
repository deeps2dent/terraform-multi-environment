data "aws_caller_identity" "current" {}

locals {
  application_bucket_name = lower(
    "${var.project_name}-${var.environment}-${data.aws_caller_identity.current.account_id}-app"
  )

  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

module "vpc" {
  source = "../../modules/vpc"

  project_name    = var.project_name
  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = local.common_tags
}

module "ec2" {
  source = "../../modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  create_instance = var.create_instance

  vpc_id    = module.vpc.vpc_id
  subnet_id = values(module.vpc.public_subnet_ids)[0]

  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  http_ingress_cidrs          = var.http_ingress_cidrs

  tags = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  project_name = var.project_name
  environment  = var.environment

  create_database = var.create_database

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = values(module.vpc.private_subnet_ids)

  allowed_security_group_ids = var.create_instance ? [
    module.ec2.security_group_id
  ] : []

  database_name   = var.database_name
  master_username = var.master_username
  master_password = var.master_password

  instance_class            = var.db_instance_class
  allocated_storage         = var.db_allocated_storage
  multi_az                  = var.db_multi_az
  backup_retention_period   = var.db_backup_retention_period
  deletion_protection       = var.db_deletion_protection
  skip_final_snapshot       = var.db_skip_final_snapshot
  final_snapshot_identifier = var.db_final_snapshot_identifier

  tags = local.common_tags
}

module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  environment  = var.environment
  bucket_name  = local.application_bucket_name

  force_destroy                      = var.storage_force_destroy
  versioning_enabled                 = var.storage_versioning_enabled
  noncurrent_version_expiration_days = var.noncurrent_version_expiration_days

  tags = local.common_tags
}