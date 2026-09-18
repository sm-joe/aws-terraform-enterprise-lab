data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "aws-terraform-enterprise-lab-tfstate-opeth"
    key    = "infrastructure/networking/terraform.tfstate"
    region = "ap-south-1"
  }
}

# ------------------------------------------------------------
# Amazon Linux 2023 - x86_64
# ------------------------------------------------------------

data "aws_ssm_parameter" "amazon_linux_2023_x86_64" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# ------------------------------------------------------------
# Amazon Linux 2023 - ARM64
# ------------------------------------------------------------

data "aws_ssm_parameter" "amazon_linux_2023_arm64" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

# ------------------------------------------------------------
# Ubuntu 24.04 - ARM64
# ------------------------------------------------------------

data "aws_ssm_parameter" "ubuntu_2404_arm64" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/arm64/hvm/ebs-gp3/ami-id"
}

data "aws_route_table" "public" {
  vpc_id = data.terraform_remote_state.networking.outputs.eu_central_1_vpc_id

  filter {
    name   = "tag:Name"
    values = ["euc1-public-rt"]
  }
}

data "aws_route_table" "private" {
  vpc_id = data.terraform_remote_state.networking.outputs.eu_central_1_vpc_id

  filter {
    name   = "tag:Name"
    values = ["euc1-private-rt"]
  }
}
