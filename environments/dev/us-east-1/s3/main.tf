module "dev_s3" {
  source      = "../../../../modules/s3"
  bucket_name = "demo-dev-opeth-123-s3"
}