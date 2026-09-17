output "us_east_1_vpc_id" {
  description = "VPC ID for us-east-1."
  value       = module.us_east_1.vpc_id
}

output "us_east_1_public_subnet_ids" {
  description = "Public subnet IDs for us-east-1."
  value       = module.us_east_1.public_subnet_ids
}

output "us_east_1_private_subnet_ids" {
  description = "Private subnet IDs for us-east-1."
  value       = module.us_east_1.private_subnet_ids
}

output "ap_south_1_vpc_id" {
  description = "VPC ID for ap-south-1."
  value       = module.ap_south_1.vpc_id
}

output "ap_south_1_public_subnet_ids" {
  description = "Public subnet IDs for ap-south-1."
  value       = module.ap_south_1.public_subnet_ids
}

output "ap_south_1_private_subnet_ids" {
  description = "Private subnet IDs for ap-south-1."
  value       = module.ap_south_1.private_subnet_ids
}

output "eu_central_1_vpc_id" {
  description = "VPC ID for eu-central-1."
  value       = module.eu_central_1.vpc_id
}

output "eu_central_1_public_subnet_ids" {
  description = "Public subnet IDs for eu-central-1."
  value       = module.eu_central_1.public_subnet_ids
}

output "eu_central_1_private_subnet_ids" {
  description = "Private subnet IDs for eu-central-1."
  value       = module.eu_central_1.private_subnet_ids
}

output "eu_central_1_vpc_cidr" {
  description = "VPC CIDR block for eu-central-1."
  value       = module.eu_central_1.vpc_cidr_block
}
