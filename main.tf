provider "aws" {
  region = "us-east-1"
  access_key = "AKIAQHZPZUUE45YGNQBD"
  secret_key = "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"
}

module "vpc" {
  source = "./modules/vpc"

  name               = var.vpc_name
  cidr_block         = var.cidr_block
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  cluster_names      = var.cluster_names
}
