output "instance_ips" {
  value = join(",", aws_instance.wordpressinstance.*.public_ip)
}

output "instance_dns" {
  value = join(",", aws_instance.wordpressinstance.*.public_dns)
}

output "lb_endpoint" {
  value = aws_lb.tudproj-LB.dns_name
}
