terraform {
  backend "s3" {
    bucket = "aws-terraform-enterprise-lab-tfstate-opeth"
    key    = "environments/prod/ap-south-1/ec2/terraform.tfstate"
    region = "ap-south-1"
  }
}
