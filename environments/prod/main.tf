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

module "app_security_group" {
  source = "../../modules/security-group"

  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Security group for application workloads."
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description              = "Allow application traffic from ALB"
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      source_security_group_id = module.app_security_group.security_group_id
    }
  ]
  tags = {
    Component = "security"
    Tier      = "private"
    Purpose   = "application"
  }
}

module "app_instance_role" {
  source = "../../modules/iam-role"

  name        = "${var.project_name}-${var.environment}-app-role"
  description = "IAM role for the development application EC2 instance."

  trusted_services = [
    "ec2.amazonaws.com"
  ]

  create_instance_profile = true

  tags = {
    Component = "iam"
    Tier      = "private"
    Purpose   = "application"
  }
}

module "app_s3" {
  source = "../../modules/s3"

  bucket_name = "${var.project_name}-${var.environment}-app-data"

  versioning_enabled = true
  force_destroy      = false

  tags = {
    Component = "storage"
    Tier      = "private"
    Purpose   = "application-data"
  }
}

module "app_s3_policy" {
  source = "../../modules/iam-policy"

  name        = "${var.project_name}-${var.environment}-app-s3-access"
  description = "Allows the application EC2 role to access the application S3 bucket."

  policy = templatefile(
    "${path.module}/iam/policies/app-s3-access.json.tpl",
    {
      bucket_arn = module.app_s3.bucket_arn
    }
  )

  role_name = module.app_instance_role.role_name

  tags = {
    Component = "iam"
    Purpose   = "application-s3-access"
  }
}

module "app_ssm_policy_attachment" {
  source = "../../modules/iam-role-policy-attachment"

  role_name  = module.app_instance_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}