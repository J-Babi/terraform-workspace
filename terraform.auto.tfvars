# EC2 Instance Terraform Module with Vertical Autoscaling

This Terraform module provisions an EC2 instance in a specified VPC and private subnet, using a Red Hat Enterprise Linux (RHEL) AMI in the `ca-central-1` region. The instance is config$

## Features

- **Vertical Autoscaling**: Automatically switch between smaller and larger instance types based on CPU utilization.
- **Security Group**: A custom security group (`rsm-dev-Cobra`) that allows inbound traffic on port 443.
- **Custom Launch Templates**: Supports two launch templates (small and large instance types) to enable vertical scaling.

## Module Structure

- `main.tf`: Defines the EC2 instance, security group, launch templates, and Auto Scaling resources.
- `variables.tf`: Contains the variables that allow customization of the EC2 instance, security group, and scaling policies.
- `outputs.tf`: Provides useful information about the created resources.

## Usage

Below is an example of how to use this module in your Terraform configuration:

```hcl
module "ec2_instance" {
  source              = "./ec2_module"
  ami_id              = "ami-0583d8c7a9c35822c" # Red Hat AMI for ca-central-1
  small_instance_type = "t2.medium"
  large_instance_type = "t2.large"
  key_name            = "pem key here"
  vpc_id              = "VPC ID here"
  private_subnet_id   = "subnet-0123456789abcdef0"
  instance_name       = "My-RedHat-Instance"
  region              = "Region here"
  volume_type         = "gp2"
  volume_size         = 20
  user_data           = file("init_script.sh")
  cidr_block          = "VPC CIDR here"
  cpu_high_threshold  = 75
  cpu_low_threshold   = 20
}
