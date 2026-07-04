variable "project_name" {
  description = "Name of the project used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment such as dev, staging, or prod"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "create_database" {
  description = "Whether to create the RDS database and related resources"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID of the VPC where the RDS security group will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the RDS subnet group"
  type        = list(string)

  validation {
    condition     = !var.create_database || length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnet IDs are required when creating RDS."
  }
}

variable "allowed_security_group_ids" {
  description = "Security group IDs allowed to connect to MySQL"
  type        = list(string)
  default     = []
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "Master database username"
  type        = string
  default     = "dbadmin"
}

variable "master_password" {
  description = "Master database password"
  type        = string
  sensitive   = true
  default     = null

  validation {
    condition = !var.create_database || try(
      length(var.master_password) >= 8 &&
      length(var.master_password) <= 41,
      false
    )

    error_message = "A password between 8 and 41 characters is required when creating RDS."
  }
}

variable "instance_class" {
  description = "RDS database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "engine_version" {
  description = "Optional MySQL engine version. Null uses the AWS default"
  type        = string
  default     = null
}

variable "allocated_storage" {
  description = "Allocated database storage in GiB"
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20
    error_message = "Allocated storage must be at least 20 GiB."
  }
}

variable "multi_az" {
  description = "Whether to deploy the RDS instance across multiple Availability Zones"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 1
}

variable "deletion_protection" {
  description = "Protect the database from accidental deletion"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the database"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Final snapshot name when skip_final_snapshot is false"
  type        = string
  default     = null

  validation {
    condition = (
      !var.create_database ||
      var.skip_final_snapshot ||
      var.final_snapshot_identifier != null
    )

    error_message = "A final snapshot identifier is required when final snapshots are enabled."
  }
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}