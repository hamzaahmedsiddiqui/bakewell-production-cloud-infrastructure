output "backend_asg_name" {
  description = "Auto Scaling Group name for backend"
  value       = aws_autoscaling_group.backend.name
}

output "backend_launch_template_id" {
  description = "Launch template ID for backend"
  value       = aws_launch_template.backend.id
}