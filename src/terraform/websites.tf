module "onway_website" {
  source = "./modules/website-bucket"

  website_url     = "www.crassus.app.br"
  certificate_arn = aws_acm_certificate.wildcard_certificate.arn
}
