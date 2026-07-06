aws_region   = "us-east-2"
project_name = "terraform-multi-environment"
environment  = "prod"

vpc_cidr = "10.30.0.0/16"

public_subnets = {
  us-east-2a = "10.30.1.0/24"
  us-east-2b = "10.30.2.0/24"
}

private_subnets = {
  us-east-2a = "10.30.11.0/24"
  us-east-2b = "10.30.12.0/24"
}

# Disabled until a controlled deployment session.
create_instance = false
instance_type   = "t3.small"

associate_public_ip_address = true

http_ingress_cidrs = [
  "0.0.0.0/0"
]

# Disabled to prevent RDS charges.
create_database = false

database_name              = "prodappdb"
master_username            = "dbadmin"
db_instance_class          = "db.t3.small"
db_allocated_storage       = 20
db_multi_az                = true
db_backup_retention_period = 7
db_deletion_protection     = true
db_skip_final_snapshot     = false

db_final_snapshot_identifier = "terraform-multi-environment-prod-final"

storage_force_destroy              = false
storage_versioning_enabled         = true
noncurrent_version_expiration_days = 90

tags = {
  Owner       = "Gurdeep"
  CostCenter  = "portfolio"
  Criticality = "production"
}