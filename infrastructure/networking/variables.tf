variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
  default     = "aws-terraform-enterprise"
}

variable "us_east_1_vpc_cidr" {
  description = "CIDR block for the us-east-1 VPC."
  type        = string
  default     = "10.10.0.0/22"
}

variable "ap_south_1_vpc_cidr" {
  description = "CIDR block for the ap-south-1 VPC."
  type        = string
  default     = "10.20.0.0/22"
}

variable "eu_central_1_vpc_cidr" {
  description = "CIDR block for the eu-central-1 VPC."
  type        = string
  default     = "10.30.0.0/22"
}
