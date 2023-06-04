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
  key_name      = var.key-pair

  security_groups = [aws_security_group.allow-ssh.id, aws_security_group.allow-http.id,
  aws_security_group.allow-https.id]

  user_data = file("../scripts/provision.sh")

  depends_on = [aws_nat_gateway.nat-gw]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wpASG" {
  name                      = "wpASG"
  min_size                  = 2
  max_size                  = 6
  desired_capacity          = 2
  health_check_grace_period = 120
  launch_configuration      = aws_launch_configuration.wordpress-LC.name
  vpc_zone_identifier       = local.private_subnets

   lifecycle { 
    ignore_changes = [desired_capacity, target_group_arns]
  }


  tag {
    key                 = "Name"
    value               = "wordpress-asg-instance"
    propagate_at_launch = true
  }
}

#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy
#

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  autoscaling_group_name = aws_autoscaling_group.wpASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 2
  cooldown               = 180
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  autoscaling_group_name = aws_autoscaling_group.wpASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
}


resource "aws_cloudwatch_metric_alarm" "cw_scale_up" {
  alarm_description   = "Monitors CPU utilization for wpASG ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  alarm_name          = "cw_scale_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  evaluation_periods  = 2
  period              = 30
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wpASG.name
  }
}


resource "aws_cloudwatch_metric_alarm" "cw_scale_down" {
  alarm_description   = "Monitors CPU utilization for wpASG ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "cw_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  evaluation_periods  = 2
  period              = 30
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wpASG.name
  }
}



