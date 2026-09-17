variable "name" {
  description = "Name of the IAM role and instance profile."
  type        = string
}

variable "description" {
  description = "Description of the IAM role."
  type        = string
  default     = null
}

variable "trusted_services" {
  description = "AWS services allowed to assume this role."
  type        = list(string)
}

variable "create_instance_profile" {
  description = "Whether to create an EC2 instance profile."
  type        = bool
  default     = false
}

variable "policy_name" {
  description = "Name of the IAM policy."
  type        = string
  default     = null
}

variable "policy_description" {
  description = "Description of the IAM policy."
  type        = string
  default     = null
}

variable "policy" {
  description = "IAM policy JSON document."
  type        = string
  default     = null
}

variable "managed_policy_arns" {
  description = "AWS managed or customer-managed policy ARNs to attach to the role."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags for the IAM resources."
  type        = map(string)
  default     = {}
}
