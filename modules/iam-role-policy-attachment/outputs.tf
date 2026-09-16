output "role_name" {
  description = "IAM role receiving the policy."
  value       = aws_iam_role_policy_attachment.this.role
}

output "policy_arn" {
  description = "Attached IAM policy ARN."
  value       = aws_iam_role_policy_attachment.this.policy_arn
}
