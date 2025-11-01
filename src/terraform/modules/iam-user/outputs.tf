output "access_key_id" {
  value     = aws_iam_access_key.access_key[0].id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.access_key[0].secret
  sensitive = true
}
