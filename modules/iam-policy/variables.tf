variable "name" {
  description = "Name of the IAM policy."
  type        = string
}

variable "description" {
  description = "Description of the IAM policy."
  type        = string
  default     = null
}

variable "policy" {
  description = "IAM policy JSON document."
  type        = string
}

variable "role_name" {
  description = "IAM role to which the policy is attached."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags for the IAM policy."
  type        = map(string)
  default     = {}
}
