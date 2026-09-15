data "aws_region" "current" {}

module "vpc" {
  source = "../../modules/vpc"

  name               = "${var.project_name}-${var.environment}"
  vpc_cidr           = "10.20.0.0/22"
  availability_zones = ["ap-south-1a", "ap-south-1b"]

  public_subnet_cidrs = [
    "10.20.0.0/24",
    "10.20.1.0/24",
  ]

  private_subnet_cidrs = [
    "10.20.2.0/24",
    "10.20.3.0/24",
  ]

  enable_nat_gateway = true

  tags = {
    Component = "networking"
  }
}