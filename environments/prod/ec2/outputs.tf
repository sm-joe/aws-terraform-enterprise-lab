output "vpn_instance_id" {
  description = "ID of the Frankfurt OpenVPN EC2 instance."
  value       = module.vpn.instance_id
}

output "vpn_private_ip" {
  description = "Private IP address of the Frankfurt OpenVPN server."
  value       = module.vpn.private_ip
}

output "vpn_public_ip" {
  description = "Elastic IP address of the Frankfurt OpenVPN server."
  value       = module.vpn.elastic_ip_address
}

output "vpn_security_group_id" {
  description = "Security group ID of the Frankfurt OpenVPN server."
  value       = aws_security_group.vpn.id
}

output "vpn_iam_role_arn" {
  description = "IAM role ARN used by the Frankfurt OpenVPN server."
  value       = module.vpn_iam.role_arn
}

output "vpn_instance_profile_name" {
  description = "IAM instance profile attached to the VPN server."
  value       = module.vpn_iam.instance_profile_name
}

output "vpn_client_cidr" {
  description = "CIDR allocated to OpenVPN clients."
  value       = var.vpn_client_cidr
}
