resource "aws_vpc" "network1" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "devsecops-vpc"
  }
}

