variable "project_name" {
  description = "Name of the project used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment such as dev, staging, or prod"
  type        = string

  validation {
    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the VPC"
  type        = string
}

variable "public_subnets" {
  description = "Map of availability zones to public subnet CIDR blocks"
  type        = map(string)
}

variable "private_subnets" {
  description = "Map of availability zones to private subnet CIDR blocks"
  type        = map(string)
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}