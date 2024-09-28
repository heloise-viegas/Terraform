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
/*
resource "aws_s3_bucket_acl" "s3_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.s3.id
  acl    = "private"
}
*/
resource "aws_s3_bucket_public_access_block" "s3_access" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/*
resource "aws_s3_bucket_website_configuration" "s3_bucket_website" {
  bucket = aws_s3_bucket.s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
*/
/* routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
  
}
*/

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3_distribution.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
