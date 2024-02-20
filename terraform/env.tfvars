prefix = "proj"

# VPC
region   = "ap-southeast-1"
#vpc_cidr = "10.1.0.0/16"

# Subnet
#subnet_cidr        = "10.1.0.0/24"
subnet_cidr        = ["172.31.48.0/24", "172.31.49.0/24"]
availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]


# Load balancer
alb_name                = "proj-alb"
alb_security_group_name = "proj-alb-sg"

# Instance
instance_type                = "t2.micro"
instance_security_group_name = "proj-ec2-sg"
http_server_port             = 80
ssh_port                     = 22

