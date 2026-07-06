variable "aws_region" {
  description = "AWS region used for the dev environment"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name used for naming and tagging resources"
  type        = string
  default     = "terraform-multi-environment"
}

variable "environment" {
  description = "Name of the deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = var.environment == "dev"
    error_message = "This configuration is specifically for the dev environment."
  }
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the dev VPC"
  type        = string
}

variable "public_subnets" {
  description = "Map of Availability Zones to public subnet CIDR blocks"
  type        = map(string)
}

variable "private_subnets" {
  description = "Map of Availability Zones to private subnet CIDR blocks"
  type        = map(string)
}

variable "create_instance" {
  description = "Whether to create the dev EC2 instance"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "EC2 instance type used in dev"
  type        = string
  default     = "t3.micro"
}

variable "associate_public_ip_address" {
  description = "Whether the EC2 instance receives a public IP address"
  type        = bool
  default     = true
}

variable "http_ingress_cidrs" {
  description = "CIDR blocks allowed to access the EC2 web server"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "create_database" {
  description = "Whether to create the dev RDS database"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "devappdb"
}

variable "master_username" {
  description = "RDS master username"
  type        = string
  default     = "dbadmin"
}

variable "master_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
  default     = null
}

variable "db_instance_class" {
  description = "RDS instance class used in dev"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GiB"
  type        = number
  default     = 20
}

variable "db_multi_az" {
  description = "Whether the dev database uses Multi-AZ"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "Number of days to retain automated database backups"
  type        = number
  default     = 1
}

variable "db_deletion_protection" {
  description = "Whether deletion protection is enabled for the dev database"
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the dev database"
  type        = bool
  default     = true
}

variable "storage_force_destroy" {
  description = "Allow the dev application bucket to be deleted when it contains objects"
  type        = bool
  default     = true
}

variable "storage_versioning_enabled" {
  description = "Whether versioning is enabled on the dev application bucket"
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Days before old S3 object versions are deleted"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional tags applied to dev resources"
  type        = map(string)
  default     = {}
}

variable "db_final_snapshot_identifier" {
  description = "Name of the final RDS snapshot when final snapshots are enabled"
  type        = string
  default     = null
}