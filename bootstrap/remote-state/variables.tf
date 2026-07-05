variable "aws_region" {
  description = "AWS region for the Terraform backend resources"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name used when naming backend resources"
  type        = string
  default     = "terraform-multi-environment"
}

variable "state_bucket_name" {
  description = "Optional custom globally unique S3 state bucket name"
  type        = string
  default     = null
}

variable "lock_table_name" {
  description = "Name of the DynamoDB state-locking table"
  type        = string
  default     = "terraform-multi-environment-locks"
}

variable "tags" {
  description = "Additional tags applied to backend resources"
  type        = map(string)
  default     = {}
}