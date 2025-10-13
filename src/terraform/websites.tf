module "onway_website" {
  source = "./modules/website-bucket"

  website_url     = "www.${var.domain}"
  certificate_arn = aws_acm_certificate.wildcard_certificate.arn
}
