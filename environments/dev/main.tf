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

module "app_ec2" {
  source = "../../modules/ec2"

  name          = "${var.project_name}-${var.environment}-app"
  ami_id        = data.aws_ami.amazon_linux.id
  instance_type = "t3a.micro"
  subnet_id     = module.vpc.private_subnet_ids[0]
  security_group_ids = [
    module.app_security_group.security_group_id
  ]
  associate_public_ip_address = false
  root_volume_size            = 20
  root_volume_type            = "gp3"

  tags = {
    Component = "compute"
    Tier      = "private"
    Purpose   = "application"
  }
}