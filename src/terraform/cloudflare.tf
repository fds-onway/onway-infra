resource "cloudflare_dns_record" "acm_certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard_certificate.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  content = each.value.value
  type    = each.value.type
  ttl     = 1
  proxied = false

  lifecycle {
    ignore_changes = all
  }
}

resource "cloudflare_dns_record" "onway_website" {
  zone_id = var.cloudflare_zone_id

  name    = "www"
  content = module.onway_website.cloudfront_endpoint
  type    = "CNAME"
  ttl     = 300
  proxied = false

  lifecycle {
    ignore_changes = all
  }
}

resource "cloudflare_dns_record" "onway_api" {
  zone_id = var.cloudflare_zone_id

  name    = "api"
  content = ""
  type    = "A"
  ttl     = 300
  proxied = false

  lifecycle {
    ignore_changes = all
  }
}

resource "cloudflare_dns_record" "onway_ses_domain_validation" {
  zone_id = var.cloudflare_zone_id
  name    = "_amazonses"
  type    = "TXT"
  ttl     = 3600
  content = aws_ses_domain_identity.onway_ses_domain.verification_token

  lifecycle {
    ignore_changes = all
  }
}

resource "cloudflare_dns_record" "ses_dkim_records" {
  for_each = toset(aws_ses_domain_dkim.onway_dkim.dkim_tokens)

  zone_id = var.cloudflare_zone_id
  name    = "${each.value}._domainkey"
  type    = "CNAME"
  ttl     = 3600
  content = "${each.value}.dkim.amazonses.com"
  proxied = false

  lifecycle {
    ignore_changes = all
  }
}
