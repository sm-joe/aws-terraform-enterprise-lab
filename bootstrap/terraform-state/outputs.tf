output "state_bucket_name" {
  description = "Name of the Terraform state S3 bucket."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_arn" {
  description = "ARN of the Terraform state S3 bucket."
  value       = aws_s3_bucket.terraform_state.arn
}

output "lock_table_name" {
  description = "Name of the Terraform state locking DynamoDB table."
  value       = aws_dynamodb_table.terraform_locks.name
}

output "lock_table_arn" {
  description = "ARN of the Terraform state locking DynamoDB table."
  value       = aws_dynamodb_table.terraform_locks.arn
}
