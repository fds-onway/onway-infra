output "cloudfront_endpoint" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.cloudfront.id
}
