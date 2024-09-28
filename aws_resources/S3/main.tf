resource "aws_s3_bucket" "s3" {
  bucket = var.s3_name

  tags = {
    Name        = var.s3_tag
    Environment = var.s3_env
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
    bucket = aws_s3_bucket.s3.id
    acl ="private"
}

resource "aws_s3_bucket" "s3_log" {
  bucket = var.s3_log_name

  tags = {
    Name        = var.s3_tag
    Environment = var.s3_env
  }
}

resource "aws_s3_bucket_acl" "s3_log_acl" {
    bucket = aws_s3_bucket.s3_log.id
    acl ="log-delivery-write"
}

resource "aws_s3_bucket_logging" "logs" {
  bucket = aws_s3_bucket.s3.id

  target_bucket = aws_s3_bucket.s3_log.id
  target_prefix = "log/"
}