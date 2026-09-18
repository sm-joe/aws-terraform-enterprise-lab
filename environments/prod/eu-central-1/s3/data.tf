data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "aws-terraform-enterprise-lab-tfstate-opeth"
    key    = "infrastructure/networking/terraform.tfstate"
    region = "ap-south-1"
  }
}
