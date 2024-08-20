#output "instance_ids" {
# description = "The IDs of the EC2 instances in the Auto Scaling group."
# value       = aws_autoscaling_group.asg.instance_ids
#}

output "availability_zones" {
  description = "The availability zones of the EC2 instances in the Auto Scaling group."
  value       = aws_autoscaling_group.asg.availability_zones
}

output "security_group_id" {
  description = "The ID of the security group rms-dev-Cobra."
  value       = aws_security_group.cobra.id
}
