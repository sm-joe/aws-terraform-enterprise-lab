output "policy_id" {
  description = "IAM policy ID."
  value       = aws_iam_policy.this.id
}

output "policy_arn" {
  description = "IAM policy ARN."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "IAM policy name."
  value       = aws_iam_policy.this.name
}