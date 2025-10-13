resource "aws_acm_certificate" "wildcard_certificate" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"
}
