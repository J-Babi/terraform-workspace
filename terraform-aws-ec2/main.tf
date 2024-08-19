provider "aws" {
  region = var.region
#    assume_role {
#      role_arn = "arn:aws:iam::${var.account-id}:role/${var.role-id}"
#      external_id = "aws-account"
#    }
}

module "terraform-aws-ec2" {
#  source  = "tfe.rogers.com/aws"
#  source  = "RogersCommunications/rsm_aws_deployment/development/DEV/terraform-aws-ec2"
#  version = "1.0.1"

# Create rsm-dev-Cobra security group
resource "aws_security_group" "cobra" {
  name        = "rsm-dev-Cobra"
  description = "Security group for rsm-dev-Cobra"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS inbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rsm-dev-Cobra"
  }
}

# Launch Template for EC2 Instance (initial size)
resource "aws_launch_template" "lt_medium" {
  name_prefix    = "lt-medium-"
  image_id       = var.ami_id
  instance_type  = var.medium_instance_type
  key_name       = var.key_name

  network_interfaces {
    subnet_id       = var.private_subnet_id
#    subnet_id       = var.public_subnet_id
    security_groups = [aws_security_group.cobra.id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  user_data = base64encode(var.user_data)

  tags = {
    Name = var.instance_name
  }
}

# Launch Template for EC2 Instance (larger size)
resource "aws_launch_template" "lt_large" {
  name_prefix    = "lt-large-"
  image_id       = var.ami_id
  instance_type  = var.large_instance_type
  key_name       = var.key_name

  network_interfaces {
    subnet_id       = var.private_subnet_id
#    subnet_id       = var.public_subnet_id
    security_groups = [aws_security_group.cobra.id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  user_data = base64encode(var.user_data)

  tags = {
    Name = var.instance_name
  }
}

# Auto Scaling Group named rsm-dev-asg with initial medium instance type
resource "aws_autoscaling_group" "asg" {
  name                      = "rsm-dev-asg"
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  vpc_zone_identifier       = [var.private_subnet_id]
#  vpc_zone_identifier       = [var.public_subnet_id]
  health_check_type         = "EC2"
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.lt_medium.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Scaling Policy to switch to larger instance type when CPU is high
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# Scaling Policy to switch back to mediumer instance type when CPU is low
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# CloudWatch Metric Alarm to trigger switch to larger instance type
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.cpu_high_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

# CloudWatch Metric Alarm to trigger switch to mediumer instance type
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low-cpu-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.cpu_low_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}
