output "s3_bucket" {
  value = aws_s3_bucket.s3.arn
}

output "cdn_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}