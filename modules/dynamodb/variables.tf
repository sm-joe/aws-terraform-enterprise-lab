variable "table_name" {
  description = "DynamoDB table name."
  type        = string
}

variable "hash_key" {
  description = "DynamoDB partition key attribute name."
  type        = string
  default     = "id"
}

variable "hash_key_type" {
  description = "DynamoDB partition key attribute type."
  type        = string
  default     = "S"

  validation {
    condition     = contains(["S", "N", "B"], var.hash_key_type)
    error_message = "hash_key_type must be S, N, or B."
  }
}

variable "billing_mode" {
  description = "DynamoDB billing mode."
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED."
  }
}

variable "tags" {
  description = "Additional tags for the DynamoDB table."
  type        = map(string)
  default     = {}
}