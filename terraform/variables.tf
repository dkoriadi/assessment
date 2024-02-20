variable "prefix" {
  description = "This prefix will be included in tags"
}

# VPC
variable "region" {
  description = "The region where the resources are created."
}

# variable "vpc_cidr" {
#   description = "VPC CIDR range e.g 10.0.0.0/16"
# }

# Subnet
variable "subnet_cidr" {
  description = "Subnet CIDR range e.g 10.0.0.0/24, must be within VPC CIDR range"
}

variable "availability_zones" {
  description = "AZ within VPC"
}

# Load balancer
variable "alb_name" {
  description = "The name of the Load Balancer"
  type        = string
}

variable "alb_security_group_name" {
  description = "The name of the security group for the ALB"
  type        = string
}

# Instance
variable "instance_type" {
  description = "Specifies the AWS instance type."
}

variable "instance_security_group_name" {
  description = "The name of the security group for the EC2 Instances"
  type        = string
}

variable "http_server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
}

variable "ssh_port" {
  description = "The port the server will use for SSH requests"
  type        = number
}

