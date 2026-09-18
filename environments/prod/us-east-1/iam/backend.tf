terraform {
  backend "s3" {
    bucket       = "aws-terraform-enterprise-lab-tfstate-opeth"
    key          = "environments/prod/us-east-1/iam/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
