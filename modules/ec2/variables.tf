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

variable "create_instance" {
  description = "Whether to create the EC2 instance and related resources"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be deployed"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Optional AMI ID. If null, the latest Amazon Linux 2023 AMI is used"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public IP address to the EC2 instance"
  type        = bool
  default     = true
}

variable "http_ingress_cidrs" {
  description = "CIDR blocks allowed to access the web server on port 80"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "user_data" {
  description = "Optional custom EC2 user data script"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}