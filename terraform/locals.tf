locals {
  instance_name    = "$(terraform.workspace)-instance"
  public_subnets   = module.vpc.public_subnets
  private_subnets  = module.vpc.private_subnets
  private_key_path = "~/.ssh/${var.key-pair}.pem"
  servers          = ["s1", "s2"]
}