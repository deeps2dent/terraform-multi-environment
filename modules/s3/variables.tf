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

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Allow deletion of the bucket even when it contains objects"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable S3 object versioning"
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Delete noncurrent object versions after this many days"
  type        = number
  default     = 30

  validation {
    condition     = var.noncurrent_version_expiration_days >= 1
    error_message = "Expiration days must be at least 1."
  }
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}