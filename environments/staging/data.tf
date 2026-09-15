# tflint-ignore: terraform_unused_declarations
data "terraform_remote_state" "shared" {
  backend = "s3"

  config = {
    bucket = "aws-terraform-enterprise-lab-tfstate-opeth"
    key    = "infrastructure/shared/terraform.tfstate"
    region = "ap-south-1"
  }
}
