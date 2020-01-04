resource "aws_acm_certificate" "cert" {
  domain_name = var.domain
}
