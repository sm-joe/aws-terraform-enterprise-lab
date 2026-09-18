# trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket" "this" {
  #checkov:skip=CKV_AWS_18:S3 access logging is intentionally not enabled for this lab Terraform state bucket.
  #checkov:skip=CKV_AWS_144:Cross-region replication is intentionally not configured for this single-region lab.
  #checkov:skip=CKV_AWS_145:AWS-managed SSE-S3 encryption is intentionally used; customer-managed KMS CMKs are not required for this lab.
  #checkov:skip=CKV2_AWS_62:Event notifications for S3 not required.
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      Name = var.bucket_name
    }
  )
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
