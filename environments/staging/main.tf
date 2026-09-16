module "promotion_test" {
  source = "../../modules/promotion-test"

  bucket_name = "opeth-demo-123-staging-promotion-test"
  environment = "staging"

  tags = {
    Component = "promotion-test"
  }
}