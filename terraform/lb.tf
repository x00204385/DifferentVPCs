resource "aws_lb_target_group" "wordpress-TG" {
  name     = "wordpress-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "wordpress-TG"
  }

}

resource "aws_lb_target_group_attachment" "wordpress-attach" {
  count            = length(aws_instance.wordpressinstance)
  target_group_arn = aws_lb_target_group.wordpress-TG.arn
  target_id        = aws_instance.wordpressinstance[count.index].id
  port             = 80
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


resource "aws_lb" "tudproj-LB" {
  name               = "wordpress-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-http.id, aws_security_group.allow-https.id]
  subnets            = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1b.id]

  enable_deletion_protection = false

  tags = {
    Name = "wordpress-LB"
  }
}
