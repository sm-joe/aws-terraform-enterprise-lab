variable "name" {
  description = "Name of the Application Load Balancer."
  type        = string
  validation {
    condition     = length(var.name) <= 32
    error_message = "The target_group_name variable must be 32 characters or less."
  }
}

variable "vpc_id" {
  description = "ID of the VPC."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets where the ALB will be deployed."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnets are required for an ALB."
  }
}

variable "security_group_ids" {
  description = "Security groups attached to the ALB."
  type        = list(string)
}

variable "target_instance_id" {
  description = "EC2 instance ID registered in the target group."
  type        = string
}

variable "target_port" {
  description = "Port exposed by the target application."
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "HTTP path used for target health checks."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Additional tags for ALB resources."
  type        = map(string)
  default     = {}
}