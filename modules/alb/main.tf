resource "aws_lb" "app_alb" {

  name               = "devops-project-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.sg_id]
  subnets = [
  var.public_subnet,
  var.public_subnet_2
]

  tags = {
    Name = "devops-project-alb"
  }

}

resource "aws_lb_target_group" "alb_target" {

  name     = "devops-target-group"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {

    path = "/"
    port = "traffic-port"

  }

}

resource "aws_lb_listener" "alb_listener" {

  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target.arn

  }

}
