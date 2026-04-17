# mon subnet public

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.network1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public Subnet"
  }
}


# mon subnet privée 

resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.network1.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private Subnet"
  }
}

