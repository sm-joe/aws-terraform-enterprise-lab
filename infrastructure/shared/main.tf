module "vpc" {
  source = "../../modules/vpc"

  name = "${var.project_name}-shared"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  nat_gateway_count  = var.nat_gateway_count

  tags = {
    Component = "networking"
    Tier      = "shared"
    Purpose   = "shared-network"
  }
}

resource "aws_s3_bucket" "atlantis_test" {
  #checkov:skip=CKV_AWS_18:S3 access logging is intentionally not enabled for this lab Terraform state bucket.
  #checkov:skip=CKV_AWS_144:Cross-region replication is intentionally not configured for this single-region lab.
  #checkov:skip=CKV_AWS_145:AWS-managed SSE-S3 encryption is intentionally used; customer-managed KMS CMKs are not required for this lab.
  #checkov:skip=CKV2_AWS_62:Event notifications for S3 not required.
  bucket = "aws-terraform-enterprise-lab-atlantis-test-638631156706"

  tags = {
    Name      = "atlantis-test"
    Component = "testing"
    ManagedBy = "Terraform"
    PRTest    = "true"
  }
}
