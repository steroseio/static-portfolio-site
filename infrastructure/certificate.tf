resource "aws_acm_certificate" "site" {
  provider = aws.cloudfront_cert

  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "site" {
  provider        = aws.cloudfront_cert
  certificate_arn = aws_acm_certificate.site.arn

  validation_record_fqdns = [for record in cloudflare_record.acm_validation : record.hostname]
}
