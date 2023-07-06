# output "instance_ips" {
#   value = join(",", aws_instance.wordpressinstance.*.public_ip)
# }

# output "instance_dns" {
#   value = join(",", aws_instance.wordpressinstance.*.public_dns)
# }

output "lb_endpoint" {
  value = aws_lb.tudproj-LB.dns_name
}

output "application_endpoint" {
  value = "https://${aws_lb.tudproj-LB.dns_name}/index.php"
}

output "asg_name" {
  value       = aws_autoscaling_group.wpASG.name
  description = "Name of the auto scaling group"
}

output "primary_nacl" {
  value = module.vpc.default_network_acl_id
  description = "The ID of the default network ACL in the VPC"

}

output "vpc_id" {
  value = module.vpc.vpc_id
  description = "Id of the VPC that was created"
}