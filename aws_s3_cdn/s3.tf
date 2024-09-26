#S3 bucket
resource "aws_s3_bucket" "s3" {
  bucket = var.s3_name

  tags = {
    Name        = var.s3_name
    Environment = var.env
  }
}
resource "aws_s3_bucket_ownership_controls" "s3_owner" {
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "s3_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.s3.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website" {
  bucket = aws_s3_bucket.s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

 /* routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
  */
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AllowGetObjects"
    Statement = [
      {
        Sid       = "AllowPublic"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.s3.arn}/**"
      }
    ]
  })
}