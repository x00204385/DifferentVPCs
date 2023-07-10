resource "aws_lb" "tudproj-LB" {
  name               = "wordpress-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-http.id, aws_security_group.allow-https.id]
  subnets            = local.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "wordpress-LB"
  }
}

resource "aws_lb_listener" "tudproj-Listener" {
  load_balancer_arn = aws_lb.tudproj-LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-TG.arn
  }
}

resource "aws_lb_target_group" "wordpress-TG" {
  name     = "wordpress-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  tags = {
    Name = "wordpress-TG"
  }

}

# Attach instances to target group 
resource "aws_lb_target_group_attachment" "wordpress-attach" {
  count            = length(local.public_subnets)
  target_group_arn = aws_lb_target_group.wordpress-TG.arn
  target_id        = module.wp_instances[count.index].id
  port             = 80
}

# Attach autoscaling group to target group 
resource "aws_autoscaling_attachment" "wpasg2tg" {
  # autoscaling_group_name = aws_autoscaling_group.wpASG.id
  autoscaling_group_name = module.autoscaling.id
  lb_target_group_arn    = aws_lb_target_group.wordpress-TG.arn
}


