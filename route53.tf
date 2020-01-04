// import zone using
// terraform import module.XXX.aws_route53_zone.root ZONE_ID
resource "aws_route53_zone" "root" {
  name = var.domain
}

// Record for 'api.' subdomain endpoint
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.root.zone_id

  name = var.api_domain
  type = "A"

  alias {
    name                   = aws_api_gateway_domain_name.api.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.api.cloudfront_zone_id
    evaluate_target_health = true
  }
}
