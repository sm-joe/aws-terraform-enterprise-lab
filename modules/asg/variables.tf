variable "name" {
  description = "Name prefix for the Auto Scaling Group."
  type        = string
}

variable "ami_id" {
  description = "AMI ID used by the launch template."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3a.micro"
}

variable "subnet_ids" {
  description = "Private subnets used by the Auto Scaling Group."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnets are required for the Auto Scaling Group."
  }
}

variable "security_group_ids" {
  description = "Security groups attached to instances."
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM instance profile attached to instances."
  type        = string
}

variable "user_data_file" {
  description = "Path to the EC2 user-data script."
  type        = string
  default     = null
}

variable "min_size" {
  description = "Minimum number of instances."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances."
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of instances."
  type        = number
  default     = 2
}

variable "target_group_arns" {
  description = "Target groups to associate with the Auto Scaling Group."
  type        = list(string)
  default     = []
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 20
}

variable "tags" {
  description = "Additional tags for ASG resources."
  type        = map(string)
  default     = {}
}