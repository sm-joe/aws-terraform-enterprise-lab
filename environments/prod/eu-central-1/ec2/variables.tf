variable "aws_region" {
  description = "AWS region for the production workload."
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name."
  type        = string
  default     = "aws-terraform-enterprise-lab"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "prod"
}

variable "vpn_client_cidr" {
  description = "CIDR assigned to OpenVPN clients."
  type        = string
  default     = "10.100.0.0/24"
}

variable "vpn_port" {
  description = "OpenVPN UDP listener port."
  type        = number
  default     = 1194
}

variable "instance_type" {
  description = "EC2 instance type for the OpenVPN server."
  type        = string
  default     = "t4g.small"
}

variable "root_volume_size" {
  description = "VPN server root volume size in GiB."
  type        = number
  default     = 8
}
