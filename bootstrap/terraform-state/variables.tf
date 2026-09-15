variable "aws_region" {
  description = "AWS region where Terraform state infrastructure will be created."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource tagging."
  type        = string
  default     = "aws-terraform-enterprise-lab"
}

variable "repository_name" {
  description = "GitHub repository name."
  type        = string
  default     = "aws-terraform-enterprise-lab"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name used for Terraform state locking."
  type        = string
  default     = "aws-terraform-enterprise-lab-terraform-locks"
}