terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
  # access_key = var.access_key
  # secret_key = var.secret_key
}
data "aws_caller_identity" "this" {}
# locals {
#   name   = "juice-shop-cluster"
#   region = "us-east-1"

#   vpc_cidr = "10.123.0.0/16"
#   azs      = ["us-east-1a", "us-east-1b"]

#   public_subnets  = ["10.123.1.0/24", "10.123.2.0/24"]
#   private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
#   intra_subnets   = ["10.123.5.0/24", "10.123.6.0/24"]

#   tags = {
#     Example = local.name
#   }
# }
