terraform {
  backend "s3" {
    bucket       = "aws-terraform-enterprise-lab-tfstate-opeth"
    key          = "dev/eu-central-1/s3/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
