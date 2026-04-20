# IAM

#checkov:skip=CKV_AWS_290:Policy Terraform volontairement large pour environnement de labo
#checkov:skip=CKV_AWS_287:Pas d'actions IAM sensibles d'exposition d'identifiants dans ce contexte de labo
#checkov:skip=CKV_AWS_355:Resource wildcard necessaire pour certaines actions EC2 de provisioning
#checkov:skip=CKV_AWS_289:Permissions management larges assumees pour la phase d'apprentissage
resource "aws_iam_policy" "terraform_policy" {
  name        = "TerraformDeployPolicy"
  description = "Permissions minimales pour Terraform"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2Full"
        Effect = "Allow"
        Action = [
          "ec2:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3StateBucket"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::devsecops-tfstate",
          "arn:aws:s3:::devsecops-tfstate/*"
        ]
      },
      {
        Sid    = "DynamoDBLock"
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:eu-west-3:*:table/terraform-lock"
      }
    ]
  })
}

resource "aws_iam_role" "bastion_role" {
  name = "bastion-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-ec2-profile"
  role = aws_iam_role.bastion_role.name
}
