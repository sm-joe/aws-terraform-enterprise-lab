variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "aws-terraform-enterprise-lab"
}

variable "instances" {
  description = "EC2 instances to provision"

  type = map(object({
    name = string
    #ami_id        = string
    os            = string
    architecture  = string
    instance_type = string
    subnet_type   = string
  }))

  validation {
    condition = alltrue([
      for instance in var.instances :
      contains(
        ["amazon-linux-2023", "windows"],
        instance.os
      )
    ])

    error_message = "os must be either amazon-linux-2023 or windows."
  }

  validation {
    condition = alltrue([
      for instance in var.instances :
      contains(
        ["x86_64", "arm64"],
        instance.architecture
      )
    ])

    error_message = "architecture must be either x86_64 or arm64."
  }

  validation {
    condition = alltrue([
      for instance in var.instances :
      instance.os != "windows" || instance.architecture == "x86_64"
    ])

    error_message = "Windows instances must use x86_64 architecture."
  }

  validation {
    condition = alltrue([
      for instance in var.instances :
      contains(
        ["public", "private"],
        instance.subnet_type
      )
    ])

    error_message = "subnet_type must be either public or private."
  }
}
