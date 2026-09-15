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

output "app_security_group_id" {
  description = "ID of the application security group."
  value       = module.app_security_group.security_group_id
}

output "app_s3_bucket_name" {
  description = "Application S3 bucket name."
  value       = module.app_s3.bucket_id
}

output "app_s3_bucket_arn" {
  description = "Application S3 bucket ARN."
  value       = module.app_s3.bucket_arn
}