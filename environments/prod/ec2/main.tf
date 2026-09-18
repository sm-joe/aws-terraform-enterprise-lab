module "vpn_iam" {
  source = "../../../modules/iam"

  name                    = "euc1-vpn-ssm-role"
  description             = "IAM role for the Frankfurt OpenVPN server."
  trusted_services        = ["ec2.amazonaws.com"]
  create_instance_profile = true

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  tags = {
    Project     = "aws-terraform-enterprise"
    Environment = "prod"
    Component   = "vpn"
    Region      = "eu-central-1"
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group" "vpn" {
  name        = "euc1-vpn-sg"
  description = "Security group for the Frankfurt OpenVPN server."
  vpc_id      = data.terraform_remote_state.networking.outputs.eu_central_1_vpc_id

  tags = {
    Name        = "euc1-vpn-sg"
    Project     = "aws-terraform-enterprise"
    Environment = "prod"
    Component   = "vpn"
    Region      = "eu-central-1"
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "openvpn" {
  security_group_id = aws_security_group.vpn.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 1194
  to_port     = 1194
  ip_protocol = "udp"

  description = "OpenVPN client connections."
}

# trivy:ignore:AVD-AWS-0104
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.vpn.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow VPN server outbound traffic."
}

module "vpn" {
  source = "../../../modules/ec2"

  name = "euc1-vpn"

  ami_id        = data.aws_ssm_parameter.ubuntu_2404_arm64.value
  instance_type = "t4g.small"

  subnet_id = data.terraform_remote_state.networking.outputs.eu_central_1_public_subnet_ids[0]

  security_group_ids = [
    aws_security_group.vpn.id
  ]

  iam_instance_profile = module.vpn_iam.instance_profile_name

  associate_public_ip_address = true
  associate_elastic_ip        = true
  source_dest_check           = false
  ebs_optimized               = true

  root_volume_type = "gp3"
  root_volume_size = 8

  user_data_file = "${path.module}/user-data/openvpn-server.sh"

  tags = {
    Project     = "aws-terraform-enterprise"
    Environment = "prod"
    Component   = "vpn"
    Region      = "eu-central-1"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route" "public_vpn_clients" {
  route_table_id         = data.aws_route_table.public.id
  destination_cidr_block = var.vpn_client_cidr
  network_interface_id   = module.vpn.network_interface_id
}

resource "aws_route" "private_vpn_clients" {
  route_table_id         = data.aws_route_table.private.id
  destination_cidr_block = var.vpn_client_cidr
  network_interface_id   = module.vpn.network_interface_id
}
