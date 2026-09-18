module "dev_s3" {
  source = "../../../modules/s3"

  bucket_name = "aws-terraform-enterprise-lab-dev-s3-${var.aws_region}-123234567678"

  versioning_enabled = false
  force_destroy      = true

  tags = {
    Project     = "aws-terraform-enterprise"
    Environment = "dev"
    Component   = "s3"
    Region      = var.aws_region
    ManagedBy   = "Terraform"
  }
}
