variable "name" {
  description = "Name prefix for VPC resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability Zones used by the VPC."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two Availability Zones are required."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "There must be one public subnet CIDR per Availability Zone."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.availability_zones)
    error_message = "There must be one private subnet CIDR per Availability Zone."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateways for private subnet egress."
  type        = bool
  default     = true
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways to create."
  type        = number
  default     = 1

  validation {
    condition     = var.nat_gateway_count >= 0 && var.nat_gateway_count <= length(var.availability_zones)
    error_message = "nat_gateway_count must be between 0 and the number of availability zones."
  }
}

variable "tags" {
  description = "Additional tags applied to VPC resources."
  type        = map(string)
  default     = {}
}