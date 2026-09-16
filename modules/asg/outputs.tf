output "autoscaling_group_id" {
  description = "Auto Scaling Group name."
  value       = aws_autoscaling_group.this.id
}

output "autoscaling_group_arn" {
  description = "Auto Scaling Group ARN."
  value       = aws_autoscaling_group.this.arn
}

output "launch_template_id" {
  description = "Launch template ID."
  value       = aws_launch_template.this.id
}

output "launch_template_arn" {
  description = "Launch template ARN."
  value       = aws_launch_template.this.arn
}
