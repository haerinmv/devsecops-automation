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
    cidr_blocks = [var.my_ip]
  }

  # sorties limitees aux mises a jour systeme

  egress {
    description = "HTTP sortant pour mises a jour"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS sortant pour mises a jour"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion-SG"
  }
}
