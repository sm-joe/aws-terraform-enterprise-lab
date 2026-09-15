variable "name" {
  description = "Name of the secret."
  type        = string
}

variable "description" {
  description = "Description of the secret."
  type        = string
  default     = null
}

variable "secret_string" {
  description = "Secret value."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Additional tags for the secret."
  type        = map(string)
  default     = {}
}