output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "elastic_ip_address" {
  description = "Elastic IP address associated with the EC2 instance."
  value       = var.associate_elastic_ip ? aws_eip.this[0].public_ip : null
}

output "elastic_ip_allocation_id" {
  description = "The allocation ID assigned to the Elastic IP."
  value       = var.associate_elastic_ip ? aws_eip.this[0].id : null
}

output "subnet_id" {
  description = "Subnet containing the EC2 instance."
  value       = aws_instance.this.subnet_id
}

output "security_group_ids" {
  description = "Security groups attached to the instance."
  value       = aws_instance.this.vpc_security_group_ids
}

output "network_interface_id" {
  description = "Primary network interface ID of the EC2 instance."
  value       = aws_instance.this.primary_network_interface_id
}
