variable "role_name" {
  description = "IAM role to which the policy is attached."
  type        = string
}

variable "policy_arn" {
  description = "ARN of the IAM policy to attach."
  type        = string
}