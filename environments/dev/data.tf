# tflint-ignore: terraform_unused_declarations
#data "aws_ami" "amazon_linux" {
#  most_recent = true
#  owners      = ["amazon"]
#
#  filter {
#    name   = "name"
#    values = ["al2023-ami-2023*-x86_64"]
#  }

#  filter {
#    name   = "state"
#    values = ["available"]
#  }

#  filter {
#    name   = "root-device-type"
#    values = ["ebs"]
#  }

#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#}

data "terraform_remote_state" "shared" {
  backend = "s3"

  config = {
    bucket = "aws-terraform-enterprise-lab-tfstate-opeth"
    key    = "infrastructure/shared/terraform.tfstate"
    region = "ap-south-1"
  }
}