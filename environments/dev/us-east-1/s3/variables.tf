variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
variable "aws_region" {
  description = "AWS region where resources are deployed."
  type        = string
  default     = "us-east-1"

  validation {
    condition = contains(
      [
        "us-east-1",
        "ap-south-1",
        "eu-central-1"
      ],
      var.aws_region
    )

    error_message = "aws_region must be us-east-1, ap-south-1, or eu-central-1."
  }
}
