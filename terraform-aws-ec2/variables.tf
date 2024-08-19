#variable "account-id" {
#  description = "The account ID"
#  type        = string
#  default     = "905418155612"
#}

variable "ami_id" {
  description = "The AMI ID to use for the instance."
  type        = string
  default     = "ami-0583d8c7a9c35822c" # Red Hat AMI for ca-central-1 region
}

variable "medium_instance_type" {
  description = "The initial (medium) EC2 instance type."
  type        = string
  default     = "t2.medium"
}

variable "large_instance_type" {
  description = "The larger EC2 instance type for vertical scaling."
  type        = string
  default     = "t2.large"
}

variable "key_name" {
  description = "The SSH key pair name to access the instance."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the instance will be deployed."
  type        = string
  default     = "vpc-0f0874df52bf77d9a"
}

variable "private_subnet_id" {
  description = "The private subnet ID in which to launch the instance."
  type        = string
  default     = "rsm-dev-private-1a"
}

#variable "public_subnet_id" {
#  description = "The public subnet ID in which to launch the instance."
#  type        = string
#  default     = "rsm-dev-public-1a"
#}

variable "instance_name" {
  description = "The name tag for the instance."
  type        = string
}

variable "volume_type" {
  description = "The type of volume to use for the root block device (e.g., gp2, io1)."
  type        = string
  default     = "gp2"
}

variable "volume_size" {
  description = "The size of the root volume in gigabytes."
  type        = number
  default     = 8
}

variable "region" {
  description = "The AWS region to deploy the instance."
  type        = string
  default     = "ca-central-1"
}

variable "user_data" {
  description = "The user data to provide when launching the instance."
  type        = string
  default     = ""
}

variable "cidr_block" {
  description = "The CIDR block to allow ingress traffic."
  type        = string
  default     = "10.95.90.0/25"
}

variable "cpu_high_threshold" {
  description = "The CPU utilization threshold to trigger scale up (switch to larger instance type)."
  type        = number
  default     = 75
}

variable "cpu_low_threshold" {
  description = "The CPU utilization threshold to trigger scale down (switch to medium instance type)."
  type        = number
  default     = 20
}
