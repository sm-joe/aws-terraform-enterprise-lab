variable "name" {
  description = "Name of the IAM role."
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

variable "managed_policy_arns" {
  description = "AWS managed policy ARNs attached to the role."
  type        = set(string)
  default     = []
}

variable "inline_policies" {
  description = "Inline IAM policies attached to the role."
  type        = map(string)
  default     = {}
}

variable "create_instance_profile" {
  description = "Whether to create an EC2 instance profile."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for the IAM role."
  type        = map(string)
  default     = {}
}