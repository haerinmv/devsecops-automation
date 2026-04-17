data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # official id of ubuntu
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# stockage de ma clef SSH

resource "aws_key_pair" "ssh-key" {
  key_name   = "cle-bastion"
  public_key = file("~/.ssh/id_ed25519.pub") 
}

# ip unique du serveur

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet_public.id

  key_name      = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true 
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]


  tags = {
    Name = "Bastion-Public"
  }
}
