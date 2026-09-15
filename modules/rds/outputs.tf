output "db_instance_id" {
  description = "RDS instance identifier."
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "RDS instance ARN."
  value       = aws_db_instance.this.arn
}

output "endpoint" {
  description = "RDS database endpoint."
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "RDS database hostname."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "RDS database port."
  value       = aws_db_instance.this.port
}

output "database_name" {
  description = "Initial database name."
  value       = aws_db_instance.this.db_name
}