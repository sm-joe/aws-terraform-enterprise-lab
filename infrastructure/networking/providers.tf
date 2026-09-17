provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "aws-terraform-enterprise"
      Environment = "shared"
      ManagedBy   = "Terraform"
      Repository  = "aws-terraform-enterprise-lab"
      Component   = "networking"
      Tier        = "shared"
      Region      = "us-east-1"
    }
  }
}

provider "aws" {
  alias  = "ap_south_1"
  region = "ap-south-1"

  default_tags {
    tags = {
      Project     = "aws-terraform-enterprise"
      Environment = "shared"
      ManagedBy   = "Terraform"
      Repository  = "aws-terraform-enterprise-lab"
      Component   = "networking"
      Tier        = "shared"
      Region      = "ap-south-1"
    }
  }
}

provider "aws" {
  alias  = "eu_central_1"
  region = "eu-central-1"

  default_tags {
    tags = {
      Project     = "aws-terraform-enterprise"
      Environment = "shared"
      ManagedBy   = "Terraform"
      Repository  = "aws-terraform-enterprise-lab"
      Component   = "networking"
      Tier        = "shared"
      Region      = "eu-central-1"
    }
  }
}
