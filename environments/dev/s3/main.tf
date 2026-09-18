module "dev_s3" {
  source = "../../../modules/s3"

  bucket_name = "aws-terraform-enterprise-dev-s3-123234567678"

  versioning_enabled = false
  force_destroy      = true

  tags = {
    Project     = "aws-terraform-enterprise"
    Environment = "dev"
    Component   = "s3"
    Region      = "us-east-1"
    ManagedBy   = "Terraform"
  }
}
