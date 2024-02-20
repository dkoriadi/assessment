terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket  = "dkoriadi-terraform-state"
    key     = "tfstate-s3-bucket"
    region  = "ap-southeast-1" # var not allowed
  }
}