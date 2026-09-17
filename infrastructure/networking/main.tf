module "us_east_1" {
  source = "../../modules/vpc"

  providers = {
    aws = aws.us_east_1
  }

  name = "use1-vpc"

  vpc_cidr = var.us_east_1_vpc_cidr

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnet_cidrs = [
    "10.10.0.0/24",
    "10.10.1.0/24"
  ]

  private_subnet_cidrs = [
    "10.10.2.0/24",
    "10.10.3.0/24"
  ]

  tags = {
    Project     = var.project_name
    Component   = "networking"
    Tier        = "shared"
    Environment = "shared"
    ManagedBy   = "Terraform"
    Repository  = "aws-terraform-enterprise-lab"
    Region      = "us-east-1"
  }
}

module "ap_south_1" {
  source = "../../modules/vpc"

  providers = {
    aws = aws.ap_south_1
  }

  name = "aps1-vpc"

  vpc_cidr = var.ap_south_1_vpc_cidr

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnet_cidrs = [
    "10.20.0.0/24",
    "10.20.1.0/24"
  ]

  private_subnet_cidrs = [
    "10.20.2.0/24",
    "10.20.3.0/24"
  ]

  tags = {
    Project     = var.project_name
    Component   = "networking"
    Tier        = "shared"
    Environment = "shared"
    ManagedBy   = "Terraform"
    Repository  = "aws-terraform-enterprise-lab"
    Region      = "ap-south-1"
  }
}

module "eu_central_1" {
  source = "../../modules/vpc"

  providers = {
    aws = aws.eu_central_1
  }

  name = "euc1-vpc"

  vpc_cidr = var.eu_central_1_vpc_cidr

  availability_zones = [
    "eu-central-1a",
    "eu-central-1b"
  ]

  public_subnet_cidrs = [
    "10.30.0.0/24",
    "10.30.1.0/24"
  ]

  private_subnet_cidrs = [
    "10.30.2.0/24",
    "10.30.3.0/24"
  ]

  tags = {
    Project     = var.project_name
    Component   = "networking"
    Tier        = "shared"
    Environment = "shared"
    ManagedBy   = "Terraform"
    Repository  = "aws-terraform-enterprise-lab"
    Region      = "eu-central-1"
  }
}
