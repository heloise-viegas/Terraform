locals {
  s3_origin_id = "${var.s3_name}-origin"
  s3_domain_name = "${var.s3_name}-s3-website-${var.region}.amazonaws.com"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = local.s3_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }



  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = var.env
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}