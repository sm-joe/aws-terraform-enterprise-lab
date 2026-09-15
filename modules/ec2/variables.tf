variable "name" {
  description = "Name of the EC2 instance."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet where the EC2 instance will be deployed."
  type        = string
}

variable "security_group_ids" {
  description = "Security groups attached to the EC2 instance."
  type        = list(string)
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address."
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GiB."
  }
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "iam_instance_profile" {
  description = "IAM instance profile attached to the EC2 instance."
  type        = string
  default     = null
}

variable "user_data_file" {
  description = "Path to the EC2 user-data shell script."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional EC2 tags."
  type        = map(string)
  default     = {}
}