variable "aws_profile" {
  description = "AWS CLI profile used by Terraform."
  type        = string
}

variable "aws_region" {
  description = "AWS region for the development environment."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name."
  type        = string
  default     = "aws-terraform-enterprise-lab"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
variable "db_master_password" {
  description = "Master password for the development PostgreSQL database."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_master_password) >= 12
    error_message = "db_master_password must be at least 12 characters."
  }
}