output "role_name" {
  description = "IAM role name."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "IAM role ARN."
  value       = aws_iam_role.this.arn
}

output "instance_profile_name" {
  description = "IAM instance profile name."
  value       = var.create_instance_profile ? aws_iam_instance_profile.this[0].name : null
}

output "instance_profile_arn" {
  description = "IAM instance profile ARN."
  value       = var.create_instance_profile ? aws_iam_instance_profile.this[0].arn : null
}

output "policy_arn" {
  description = "IAM policy ARN."
  value       = var.policy != null ? aws_iam_policy.this[0].arn : null
}
