output "vpc_id" {
  description = "ID of the development VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.vpc.private_subnet_ids
}

output "alb_security_group_id" {
  description = "ID of the ALB security group."
  value       = module.alb_security_group.security_group_id
}

output "app_security_group_id" {
  description = "ID of the application security group."
  value       = module.app_security_group.security_group_id
}

output "db_security_group_id" {
  description = "ID of the database security group."
  value       = module.db_security_group.security_group_id
}