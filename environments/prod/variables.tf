variable "aws_profile" {
  description = "AWS CLI profile used by Terraform."
  type        = string
  default     = "default"
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
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}