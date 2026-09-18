terraform {
  backend "s3" {
    bucket       = "aws-terraform-enterprise-lab-tfstate-opeth"
    key          = "prod/ap-south-1/iam/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
