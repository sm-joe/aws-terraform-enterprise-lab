variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

variable "environment" {
  description = "Environment associated with the bucket."
  type        = string
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}