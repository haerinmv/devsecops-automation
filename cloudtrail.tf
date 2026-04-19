# Bucket S3 dédié aux logs CloudTrail

resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "devsecops-cloudtrail-logs"

  tags = {
    Name = "CloudTrail Logs"
  }
}

# Chiffrement du bucket de logs

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloquer l'accès public aux logs

resource "aws_s3_bucket_public_access_block" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Policy pour autoriser CloudTrail à écrire dans le bucket

resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_logs.arn}/*"
      },
      {
        Sid    = "CloudTrailCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_logs.arn
      }
    ]
  })
}


resource "aws_cloudtrail" "main" {
  name                       = "devsecops-trail"
  s3_bucket_name             = aws_s3_bucket.cloudtrail_logs.id
  is_multi_region_trail      = false
  enable_log_file_validation = true

  tags = {
    Name = "DevSecOps CloudTrail"
  }
}
