output "vpc_id" {
  description = "ID of the shared VPC."
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "ARN of the shared VPC."
  value       = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the shared VPC."
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the shared public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the shared private subnets."
  value       = module.vpc.private_subnet_ids
}

output "public_route_table_id" {
  description = "ID of the shared public route table."
  value       = module.vpc.public_route_table_id
}

output "private_route_table_ids" {
  description = "IDs of the shared private route tables."
  value       = module.vpc.private_route_table_ids
}

#output "nat_gateway_ids" {
#  description = "IDs of the shared NAT Gateways."
#  value       = module.vpc.nat_gateway_ids
#}

output "internet_gateway_id" {
  description = "ID of the shared Internet Gateway."
  value       = module.vpc.internet_gateway_id
}
