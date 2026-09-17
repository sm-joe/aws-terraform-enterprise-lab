output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "elastic_ip_address" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.this.public_ip
}

output "elastic_ip_allocation_id" {
  description = "The allocation ID assigned by AWS"
  value       = aws_eip.this[*].id
}

output "subnet_id" {
  description = "Subnet containing the EC2 instance."
  value       = aws_instance.this.subnet_id
}

output "security_group_ids" {
  description = "Security groups attached to the instance."
  value       = aws_instance.this.vpc_security_group_ids
}
