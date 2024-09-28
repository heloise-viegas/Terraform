locals {
  s3_origin_id   = "${var.s3_name}-origin"
  s3_domain_name = aws_s3_bucket.s3.bucket_regional_domain_name
  #"${var.s3_name}-s3-website-${var.region}.amazonaws.com"
}

resource "aws_cloudfront_origin_access_identity" "s3_distribution" {}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = local.s3_domain_name
    origin_id                = local.s3_origin_id

     s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_distribution.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  #comment             = "Some comment"
  default_root_object = "index.html"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "mylogs.s3.amazonaws.com"
  #   prefix          = "myprefix"
  # }

  # aliases = ["mysite.example.com", "yoursite.example.com"]

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

custom_error_response {
    error_code            = 403
    error_caching_min_ttl = 30
    response_code         = 200
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_code            = 400
    error_caching_min_ttl = 30
    response_code         = 200
    response_page_path    = "/index.html"
  }

}
