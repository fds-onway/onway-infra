output "server_private_key" {
  value     = tls_private_key.deployer_key.private_key_pem
  sensitive = true
}

output "server_public_ip_address" {
  value     = aws_instance.onway_server.public_ip
  sensitive = true
}

output "api_cloudfront_id" {
  value = module.onway_api_cloudfront.cloudfront_id
}

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
