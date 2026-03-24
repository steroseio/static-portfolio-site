data "cloudflare_zone" "site" {
  name = var.domain_name
}

resource "cloudflare_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.site.domain_validation_options : dvo.domain_name => {
      name    = replace(dvo.resource_record_name, "/\\.$/", "")
      type    = dvo.resource_record_type
      content = replace(dvo.resource_record_value, "/\\.$/", "")
    }
  }

  zone_id = data.cloudflare_zone.site.id
  name    = each.value.name
  type    = each.value.type
  content = each.value.content
  ttl     = 300
  proxied = false
}

resource "cloudflare_record" "apex" {
  zone_id = data.cloudflare_zone.site.id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 300
  content = aws_cloudfront_distribution.site.domain_name
  proxied = false
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zone.site.id
  name    = "www"
  type    = "CNAME"
  ttl     = 300
  content = aws_cloudfront_distribution.site.domain_name
  proxied = false
}
