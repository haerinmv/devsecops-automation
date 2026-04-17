output "bastion_public_ip" {
  description = "L'adresse IP publique du Bastion"
  value       = aws_instance.bastion.public_ip
}

output "vpc_id" {
  description = "L'ID du VPC"
  value       = aws_vpc.network1.id
}
