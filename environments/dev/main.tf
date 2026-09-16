module "app_security_group" {
  source = "../../modules/security-group"

  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Security group for application workloads."
  vpc_id      = data.terraform_remote_state.shared.outputs.vpc_id

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
  force_destroy      = true

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

### Demo Testing ###