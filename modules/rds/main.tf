locals {
  name_prefix   = "${var.project_name}-${var.environment}"
  db_identifier = lower("${var.project_name}-${var.environment}-mysql")

  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

resource "aws_db_subnet_group" "this" {
  count = var.create_database ? 1 : 0

  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-db-subnet-group"
    }
  )
}

resource "aws_security_group" "this" {
  count = var.create_database ? 1 : 0

  name        = "${local.name_prefix}-rds-sg"
  description = "Security group for the ${local.name_prefix} RDS database"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  for_each = var.create_database ? toset(var.allowed_security_group_ids) : toset([])

  security_group_id            = aws_security_group.this[0].id
  referenced_security_group_id = each.value

  description = "Allow MySQL from an approved application security group"
  ip_protocol = "tcp"
  from_port   = 3306
  to_port     = 3306
}

resource "aws_db_instance" "this" {
  count = var.create_database ? 1 : 0

  identifier = local.db_identifier

  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.database_name
  username = var.master_username
  password = var.master_password

  db_subnet_group_name   = aws_db_subnet_group.this[0].name
  vpc_security_group_ids = [aws_security_group.this[0].id]

  multi_az            = var.multi_az
  publicly_accessible = false

  backup_retention_period    = var.backup_retention_period
  auto_minor_version_upgrade = true
  apply_immediately          = true

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : var.final_snapshot_identifier
  delete_automated_backups  = true
  copy_tags_to_snapshot     = true

  tags = merge(
    local.common_tags,
    {
      Name = local.db_identifier
    }
  )
}