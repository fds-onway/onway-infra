resource "aws_ses_domain_identity" "onway_ses_domain" {
  domain = var.domain
}

resource "aws_ses_domain_dkim" "onway_dkim" {
  domain = aws_ses_domain_identity.onway_ses_domain.domain
}

resource "aws_ses_domain_identity_verification" "onway_ses_domain_verification" {
  domain = aws_ses_domain_identity.onway_ses_domain.id

  depends_on = [
    cloudflare_dns_record.ses_dkim_records,
    cloudflare_dns_record.onway_ses_domain_validation
  ]
}
