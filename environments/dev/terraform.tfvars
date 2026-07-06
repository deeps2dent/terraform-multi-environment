aws_region   = "us-east-2"
project_name = "terraform-multi-environment"
environment  = "dev"

vpc_cidr = "10.10.0.0/16"

public_subnets = {
  us-east-2a = "10.10.1.0/24"
  us-east-2b = "10.10.2.0/24"
}

private_subnets = {
  us-east-2a = "10.10.11.0/24"
  us-east-2b = "10.10.12.0/24"
}

# Keep paid compute disabled initially.
create_instance = false
instance_type   = "t3.micro"

associate_public_ip_address = true

http_ingress_cidrs = [
  "0.0.0.0/0"
]

# Keep RDS disabled initially to avoid hourly charges.
create_database = false

database_name              = "devappdb"
master_username            = "dbadmin"
db_instance_class          = "db.t3.micro"
db_allocated_storage       = 20
db_multi_az                = false
db_backup_retention_period = 1
db_deletion_protection     = false
db_skip_final_snapshot     = true

storage_force_destroy              = true
storage_versioning_enabled         = true
noncurrent_version_expiration_days = 30

tags = {
  Owner      = "Gurdeep"
  CostCenter = "portfolio"
}