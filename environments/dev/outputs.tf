output "vpc_id" {
  description = "ID of the development VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.vpc.private_subnet_ids
}

output "app_autoscaling_group_name" {
  description = "Name of the development application Auto Scaling Group."
  value       = module.app_asg.autoscaling_group_id
}

output "app_launch_template_id" {
  description = "ID of the development application launch template."
  value       = module.app_asg.launch_template_id
}

output "alb_security_group_id" {
  description = "ID of the ALB security group."
  value       = module.alb_security_group.security_group_id
}

output "app_security_group_id" {
  description = "ID of the application security group."
  value       = module.app_security_group.security_group_id
}

output "db_security_group_id" {
  description = "ID of the database security group."
  value       = module.db_security_group.security_group_id
}

output "app_alb_dns_name" {
  description = "DNS name of the development application ALB."
  value       = module.app_alb.load_balancer_dns_name
}

output "app_rds_endpoint" {
  description = "Endpoint of the development PostgreSQL database."
  value       = module.app_rds.endpoint
}

output "app_rds_address" {
  description = "Hostname of the development PostgreSQL database."
  value       = module.app_rds.address
}

output "app_rds_port" {
  description = "Port of the development PostgreSQL database."
  value       = module.app_rds.port
}

output "app_s3_bucket_name" {
  description = "Application S3 bucket name."
  value       = module.app_s3.bucket_id
}

output "app_s3_bucket_arn" {
  description = "Application S3 bucket ARN."
  value       = module.app_s3.bucket_arn
}

output "app_dynamodb_table_name" {
  description = "Application DynamoDB table name."
  value       = module.app_dynamodb.table_name
}

output "app_dynamodb_table_arn" {
  description = "Application DynamoDB table ARN."
  value       = module.app_dynamodb.table_arn
}

output "app_db_secret_arn" {
  description = "ARN of the application database secret."
  value       = module.app_db_secret.secret_arn
}