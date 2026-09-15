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

module "alb_security_group" {
  source = "../../modules/security-group"

  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for the development application load balancer."
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "Allow HTTP from the Internet"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS from the Internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Component = "security"
    Tier      = "public"
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
      source_security_group_id = module.alb_security_group.security_group_id
    }
  ]
  tags = {
    Component = "security"
    Tier      = "private"
    Purpose   = "application"
  }
}

module "db_security_group" {
  source = "../../modules/security-group"

  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "Security group for database workloads."
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description              = "Allow PostgreSQL from application workloads"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = module.app_security_group.security_group_id
    }
  ]

  tags = {
    Component = "security"
    Tier      = "private"
    Purpose   = "database"
  }
}

module "app_asg" {
  source = "../../modules/asg"

  name = "${var.project_name}-${var.environment}-app-asg"

  ami_id        = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_ids = module.vpc.private_subnet_ids

  security_group_ids = [
    module.app_security_group.security_group_id
  ]

  iam_instance_profile = module.app_instance_role.instance_profile_name

  user_data_file = "${path.module}/../../modules/ec2/user_data/app.sh"

  min_size         = 1
  max_size         = 2
  desired_capacity = 2

  target_group_arns = [
    module.app_alb.target_group_arn
  ]

  root_volume_size = 20

  tags = {
    Component = "compute"
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

module "app_alb" {
  source = "../../modules/alb"

  name = substr("${var.project_name}-${var.environment}-alb", 0, 32)

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.public_subnet_ids

  security_group_ids = [
    module.alb_security_group.security_group_id
  ]

  target_port = 8080

  health_check_path = "/"

  tags = {
    Component = "load-balancing"
    Tier      = "public"
    Purpose   = "application"
  }
}

module "app_rds" {
  source = "../../modules/rds"

  name       = "${var.project_name}-${var.environment}-postgres"
  identifier = "${var.project_name}-${var.environment}-postgres"

  engine         = "postgres"
  engine_version = "17"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  database_name = "appdb"

  master_username = "labadmin"
  master_password = var.db_master_password

  port = 5432

  subnet_ids = module.vpc.private_subnet_ids

  security_group_ids = [
    module.db_security_group.security_group_id
  ]

  multi_az = false

  backup_retention_period = 0

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Component = "database"
    Tier      = "private"
    Purpose   = "application"
  }
}

module "app_db_secret" {
  source = "../../modules/secrets-manager"

  name        = "${var.project_name}/${var.environment}/database"
  description = "Database credentials for the development application."

  secret_string = jsonencode({
    username = "labadmin"
    password = var.db_master_password
    database = "appdb"
    host     = module.app_rds.address
    port     = module.app_rds.port
  })

  tags = {
    Component = "security"
    Tier      = "private"
    Purpose   = "database-credentials"
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

module "app_dynamodb" {
  source = "../../modules/dynamodb"

  table_name = "${var.project_name}-${var.environment}-app"

  hash_key      = "id"
  hash_key_type = "S"

  billing_mode = "PAY_PER_REQUEST"

  tags = {
    Component = "database"
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

module "app_secrets_policy" {
  source = "../../modules/iam-policy"

  name        = "${var.project_name}-${var.environment}-app-secrets-access"
  description = "Allows the application EC2 role to read the application database secret."

  policy = templatefile(
    "${path.module}/iam/policies/app-secrets-access.json.tpl",
    {
      secret_arn = module.app_db_secret.secret_arn
    }
  )

  role_name = module.app_instance_role.role_name

  tags = {
    Component = "iam"
    Purpose   = "application-secrets-access"
  }
}

module "app_ssm_policy_attachment" {
  source = "../../modules/iam-role-policy-attachment"

  role_name  = module.app_instance_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}