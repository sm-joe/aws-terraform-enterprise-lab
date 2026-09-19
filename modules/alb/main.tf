# trivy:ignore:AVD-AWS-0053
resource "aws_lb" "this" {
  #checkov:skip=CKV_AWS_131:ALB - Not required for lab environment.
  #checkov:skip=CKV_AWS_91:ALB - Not required for lab environment.
  #checkov:skip=CKV_AWS_150:ALB - Not required for lab environment.
  #checkov:skip=CKV2_AWS_20:ALB - Not required for lab environment.
  #checkov:skip=CKV2_AWS_28:ALB - Not required for lab environment.
  name               = substr("${var.name}", 0, 32)
  internal           = false
  load_balancer_type = "application"
  drop_invalid_header_fields = true

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
  #checkov:skip=CKV_AWS_378:Load Balancer - Not required for lab environment.
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

# trivy:ignore:AVD-AWS-0054
resource "aws_lb_listener" "http" {
  #checkov:skip=CKV_AWS_2:EC2 - Not required for lab environment.
  #checkov:skip=CKV_AWS_103:Security Group - Not required for lab environment.
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
