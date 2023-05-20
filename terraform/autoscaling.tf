# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

locals {
  instance_name    = "$(terraform.workspace)-instance"
  public_subnets   = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1b.id]
  private_subnets  = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id]
  private_key_path = "~/.ssh/${var.key-pair}.pem"
  servers          = ["s1", "s2"]
}


resource "aws_launch_configuration" "wordpress-LC" {
  name_prefix   = "wordpress-instance"
  image_id      = var.instance-ami
  instance_type = "t2.micro"
  user_data     = file("ec2-init.sh")
  key_name      = var.key-pair

  security_groups = [aws_security_group.allow-ssh.id, aws_security_group.allow-http.id,
  aws_security_group.allow-https.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wpASG" {
  name                 = "wpASG"
  min_size             = 2
  max_size             = 6
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.wordpress-LC.name
  vpc_zone_identifier  = local.public_subnets

  tag {
    key                 = "Name"
    value               = "wordpress-asg-instance"
    propagate_at_launch = true
  }
}