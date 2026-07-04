output "instance_id" {
  description = "ID of the EC2 instance"
  value       = try(aws_instance.this[0].id, null)
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = try(aws_instance.this[0].public_ip, null)
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = try(aws_instance.this[0].private_ip, null)
}

output "security_group_id" {
  description = "ID of the EC2 security group"
  value       = try(aws_security_group.this[0].id, null)
}

output "iam_role_name" {
  description = "Name of the EC2 IAM role"
  value       = try(aws_iam_role.this[0].name, null)
}

output "instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = try(aws_iam_instance_profile.this[0].name, null)
}