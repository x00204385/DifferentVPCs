# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
#
data "aws_route53_zone" "hosted_zone" {
  name = "iac4fun.com"
}


resource "aws_route53_record" "site_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "wordpress.iac4fun.com"
  type    = "A"

  alias {
    name                   = aws_lb.tudproj-LB.dns_name
    zone_id                = aws_lb.tudproj-LB.zone_id
    evaluate_target_health = true
  }
}
