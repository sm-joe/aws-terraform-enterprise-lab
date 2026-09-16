module "promotion_test" {
  source = "../../modules/promotion-test"

  bucket_name = "opeth-demo-123-prod-promotion-test"
  environment = "prod"

  tags = {
    Component = "promotion-test"
  }
}