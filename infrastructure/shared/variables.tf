variable "aws_profile" {
  description = "AWS CLI profile used by Terraform."
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region for shared infrastructure."
  type        = string
  default     = "ap-south-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "aws_region must be a valid AWS region identifier."
  }
}

variable "project_name" {
  description = "Project name."
  type        = string
  default     = "aws-terraform-enterprise-lab"
}

variable "vpc_cidr" {
  description = "CIDR block for the shared VPC."
  type        = string
  default     = "10.20.0.0/22"
}

variable "availability_zones" {
  description = "Availability Zones used by the shared VPC."
  type        = list(string)

  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two Availability Zones are required."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for shared public subnets."
  type        = list(string)

  default = [
    "10.20.0.0/24",
    "10.20.1.0/24"
  ]

  validation {
    condition     = length(var.public_subnet_cidrs) > 0
    error_message = "At least one public subnet CIDR is required."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for shared private subnets."
  type        = list(string)

  default = [
    "10.20.2.0/24",
    "10.20.3.0/24"
  ]

  validation {
    condition     = length(var.private_subnet_cidrs) > 0
    error_message = "At least one private subnet CIDR is required."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway resources for private subnet egress."
  type        = bool
  default     = true
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways to create."
  type        = number
  default     = 1

  validation {
    condition     = var.nat_gateway_count >= 0
    error_message = "nat_gateway_count must be zero or greater."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "shared"

  validation {
    condition     = contains(["dev", "staging", "prod", "shared"], var.environment)
    error_message = "Environment must be dev, staging, prod or shared."
  }
}

check "subnet_configuration" {
  assert {
    condition = (
      length(var.public_subnet_cidrs) == length(var.availability_zones) &&
      length(var.private_subnet_cidrs) == length(var.availability_zones)
    )

    error_message = "The number of public and private subnet CIDRs must match the number of Availability Zones."
  }
}