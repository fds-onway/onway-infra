resource "aws_s3_bucket" "cdn_bucket" {
  bucket = "onway-cdn-bucket"

  tags = {
    Name = "onway-cdn-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "cdn_bucket_ownership_controls" {
  bucket = aws_s3_bucket.cdn_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "cdn_bucket_access_block" {
  bucket = aws_s3_bucket.cdn_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "cdn_bucket_acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.cdn_bucket_access_block,
    aws_s3_bucket_ownership_controls.cdn_bucket_ownership_controls
  ]

  bucket = aws_s3_bucket.cdn_bucket.id
  acl = "public-read"
}

resource "aws_s3_bucket_policy" "cdn_bucket_policy" {
  bucket = aws_s3_bucket.cdn_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.cdn_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "cdn_bucket_cors_configuration" {
  bucket = aws_s3_bucket.cdn_bucket.id

  cors_rule {
    allowed_headers = [ "*" ]
    allowed_methods = [ "GET", "POST", "PUT", "DELETE", "HEAD" ]
    allowed_origins = [ "*" ]
    expose_headers  = [ "ETag" ]
    max_age_seconds = 3000
  }
}

