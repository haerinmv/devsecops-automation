# mon subnet public

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.network1.id
  cidr_block = var.public_subnet_cidr
  tags = {
    Name = "Public Subnet"
  }
}


# mon subnet privée 

resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.network1.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "Private Subnet"
  }
}

