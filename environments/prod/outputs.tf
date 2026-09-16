output "s3_bucket_id" {
  description = "The name/ID of the S3 bucket"
  value       = module.promotion_test.bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.promotion_test.bucket_arn
}

output "s3_bucket_domain_name" {
  description = "The bucket domain name"
  value       = module.promotion_test.s3_bucket_domain_name
}