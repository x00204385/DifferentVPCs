# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
#
# 
# Hosted zone already exists. Import it
#
data "aws_route53_zone" "hosted_zone" {
  name = "iac4fun.com"
}


#
# Create A record to point to primary or secondary load balancer
# Details of record created depend on var.primary (bool)
#
resource "aws_route53_record" "site_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "wordpress.iac4fun.com"
  type    = "A"

  alias {
    name                   = aws_lb.tudproj-LB.dns_name
    zone_id                = aws_lb.tudproj-LB.zone_id
    evaluate_target_health = var.primary ? true : false
  }

  failover_routing_policy {
    type = var.primary ? "PRIMARY" : "SECONDARY"
  }

  set_identifier  = var.primary ? "primary" : "secondary"
  health_check_id = var.primary ? aws_route53_health_check.primary-health[0].id : null
}

resource "aws_route53_health_check" "primary-health" {
  count             = var.primary ? 1 : 0 # Only need a health check for the primary zone
  fqdn              = aws_lb.tudproj-LB.dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "2"
  request_interval  = "30"

  tags = {
    Name = "route53-primary-load-balancer"
  }
}
