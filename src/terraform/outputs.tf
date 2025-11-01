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

output "onway_droplet_ip_address" {
  value = digitalocean_droplet.onway_droplet.ipv4_address
}


# IAM Users
# =======================================
output "onway_ses_user_access_key_id" {
  value     = module.onway_ses_iam_user.access_key_id
  sensitive = true
}

output "onway_ses_user_secret_access_key" {
  value     = module.onway_ses_iam_user.secret_access_key
  sensitive = true
}
