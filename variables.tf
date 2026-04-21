variable "aws_region" {
  description = "region AWS"
  type        = string
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "Le type d'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "vpc_cidr" {
  description = "Le CIDR block du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Le CIDR du subnet public"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Le CIDR du subnet privé"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ssh_public_key" {
  description = "Contenu de la clé publique SSH"
  type        = string
  default     = ""
}

variable "my_ip" {
  description = "Mon IP publique pour SSH"
  type        = string
}
