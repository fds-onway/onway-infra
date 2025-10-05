module "onway_api_cloudfront" {
  source = "../modules/cloudfront-distribution"

  domain          = "api.crassus.app.br"
  public_dns      = aws_instance.onway_server.public_dns
  certificate_arn = aws_acm_certificate.wildcard_certificate.arn
}
