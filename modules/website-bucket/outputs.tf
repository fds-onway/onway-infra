output "cloudfront_endpoint" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}
