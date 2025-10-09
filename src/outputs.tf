output "website_cloudfront_id" {
  value = module.onway_website.cloudfront_id
}

output "cloudfront_manager_access_key_id" {
  value = aws_iam_access_key.cloudfront_manager_access_key.id
}

output "cloudfront_manager_secret_access_key" {
  value     = aws_iam_access_key.cloudfront_manager_access_key.secret
  sensitive = true
}
