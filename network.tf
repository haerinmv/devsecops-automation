resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.network1.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.network1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rt_public.id
}
