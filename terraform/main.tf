#
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/4.0.2
#
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"

  name = "wp"
  cidr = var.vpc_cidr_block

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidr_blocks
  private_subnet_names = ["private-subnet-1a", "private-subnet-1b"]

  public_subnets  = var.public_subnet_cidr_blocks
  public_subnet_names = ["public-subnet-1a", "public-subnet-1b"]


  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = true
  one_nat_gateway_per_az = false


  enable_dns_hostnames = true
  enable_dns_support   = true

  map_public_ip_on_launch = true

}


module wp_instances {
  source = "./modules/wp_instances"

  count         = length(local.public_subnets)

  subnet_id = local.public_subnets[count.index]


  security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-http.id,
   aws_security_group.allow-https.id]

}

module autoscaling {
    source = "./modules/autoscaling"

    subnets = local.private_subnets

security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-http.id,
   aws_security_group.allow-https.id]
}

