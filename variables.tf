variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "key" {
  type = string
}

variable "availability_zone" {
  description = "Availability Zone for the EBS volume"
  type        = string
}

variable "ebs_volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
  default     = 10
}

variable "ebs_volume_type" {
  description = "Type of EBS volume"
  type        = string
  default     = "gp2"
}

variable "device_name" {
  description = "Device name to attach the EBS volume"
  type        = string
  default     = "/dev/sdf"
}