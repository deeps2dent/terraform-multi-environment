output "vpc_id" {
  description = "ID of the production VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs in the production environment"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs in the production environment"
  value       = module.vpc.private_subnet_ids
}

output "ec2_instance_id" {
  description = "ID of the production EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the production EC2 instance"
  value       = module.ec2.public_ip
}

output "rds_endpoint" {
  description = "Endpoint of the production RDS database"
  value       = module.rds.database_endpoint
  sensitive   = true
}

output "application_bucket_name" {
  description = "Name of the production application S3 bucket"
  value       = module.s3.bucket_id
}