# Bucket S3 dédié aux logs CloudTrail

resource "aws_s3_bucket" "cloudtrail_logs" {
  #checkov:skip=CKV_AWS_18:Access logging skipped to keep the lab low cost and avoid recursive log bucket complexity.
  #checkov:skip=CKV2_AWS_62:Event notifications are left as a future detection improvement for this lab.
  bucket = "devsecops-cloudtrail-logs"

  tags = {
    Name = "CloudTrail Logs"
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  rule {
    id     = "expire-cloudtrail-logs"
    status = "Enabled"

    filter {
      prefix = ""
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    expiration {
      days = 180
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
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
  #checkov:skip=CKV2_AWS_10:CloudWatch Logs integration is planned for a detection phase; S3 CloudTrail is enough for this budget lab.
  #checkov:skip=CKV_AWS_35:KMS CMK encryption skipped for cost; the S3 bucket uses SSE-S3 for this lab.
  #checkov:skip=CKV_AWS_67:Single-region CloudTrail is enough for this eu-west-3 lab; multi-region is a production improvement.
  #checkov:skip=CKV_AWS_252:SNS notifications are planned for a detection phase and skipped to keep this lab simple.
  name                       = "devsecops-trail"
  s3_bucket_name             = aws_s3_bucket.cloudtrail_logs.id
  is_multi_region_trail      = false
  enable_log_file_validation = true

  tags = {
    Name = "DevSecOps CloudTrail"
  }
}
