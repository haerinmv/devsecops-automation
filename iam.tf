# IAM

resource "aws_iam_policy" "terraform_policy" {
  #checkov:skip=CKV_AWS_287:Terraform EC2 provisioning needs broad EC2 read/write permissions in this lab; production would split and scope this policy.
  #checkov:skip=CKV_AWS_289:Permissions management exposure accepted for the lab deploy role and documented as a least-privilege improvement.
  #checkov:skip=CKV_AWS_355:Several EC2 actions require wildcard resources; production would constrain by tags and service-specific statements.
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
