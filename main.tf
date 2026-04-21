resource "aws_vpc" "network1" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "devsecops-vpc"
  }
}

resource "aws_default_security_group" "network1" {
  vpc_id = aws_vpc.network1.id

  tags = {
    Name = "devsecops-default-sg-restricted"
  }
}
