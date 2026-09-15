output "app_s3_bucket_name" {
  description = "Application S3 bucket name."
  value       = module.app_s3.bucket_id
}

output "app_s3_bucket_arn" {
  description = "Application S3 bucket ARN."
  value       = module.app_s3.bucket_arn
}