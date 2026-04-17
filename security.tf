resource "aws_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  description = "Autorise SSH uniquement depuis mon IP"
  vpc_id      = aws_vpc.network1.id

# seul ssh sur le port 22 est autorisé

  ingress {
    description = "SSH depuis mon IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # On mettra ton IP précise plus tard !
  }

# peut aller partout pour recuperer des maj

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion-SG"
  }
}
