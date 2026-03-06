resource "aws_launch_template" "lt" {

  name_prefix   = "devops-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.sg_id]

  user_data = base64encode(<<EOF
#!/bin/bash
apt update -y
apt install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<h1>DevOps Terraform Project</h1>" > /var/www/html/index.html
EOF
)

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "autoscaling-ec2"
    }

  }

}

resource "aws_autoscaling_group" "asg" {

  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = [var.private_subnet]

  launch_template {

    id      = aws_launch_template.lt.id
    version = "$Latest"

  }

  target_group_arns = [var.target_group_arn]

}

resource "aws_autoscaling_policy" "scale_up" {

  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg.name

}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {

  alarm_name          = "cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {

    AutoScalingGroupName = aws_autoscaling_group.asg.name

  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]

}
