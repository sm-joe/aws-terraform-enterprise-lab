resource "aws_lb" "this" {
  name               = substr("${var.name}", 0, 32)
  internal           = false
  load_balancer_type = "application"

  security_groups = var.security_group_ids
  subnets         = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_lb_target_group" "this" {
  name        = substr("${var.name}-tg", 0, 32)
  port        = var.target_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-tg"
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}