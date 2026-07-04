output "database_instance_id" {
  description = "ID of the RDS database instance"
  value       = try(aws_db_instance.this[0].id, null)
}

output "database_arn" {
  description = "ARN of the RDS database instance"
  value       = try(aws_db_instance.this[0].arn, null)
}

output "database_endpoint" {
  description = "Connection endpoint of the RDS database"
  value       = try(aws_db_instance.this[0].address, null)
}

output "database_port" {
  description = "Port used by the RDS database"
  value       = try(aws_db_instance.this[0].port, null)
}

output "database_name" {
  description = "Name of the initial database"
  value       = try(aws_db_instance.this[0].db_name, null)
}

output "security_group_id" {
  description = "ID of the RDS security group"
  value       = try(aws_security_group.this[0].id, null)
}

output "db_subnet_group_name" {
  description = "Name of the RDS subnet group"
  value       = try(aws_db_subnet_group.this[0].name, null)
}