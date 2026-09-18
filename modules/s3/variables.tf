variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

variable "versioning_enabled" {
  description = "Whether S3 object versioning is enabled."
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Whether Terraform may delete objects when destroying the bucket."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags for the S3 bucket."
  type        = map(string)
  default     = {}
}
