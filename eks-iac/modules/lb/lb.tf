resource "aws_lb" "nlb" {
  name               = var.lb_name
  internal           = true
  load_balancer_type = var.lb_type
  subnets            = var.lb_subnets
  tags = {
    Environment = "${var.env}"
    Application = var.app
  }
}
resource "aws_lb_target_group" "alb" {
  name        = var.tg_name
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  health_check {
    path = var.tg_healthcheck_path
  }
}
resource "aws_lb_target_group" "alb_443" {
  name        = var.tg_name_tls
  target_type = "alb"
  port        = 443
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  health_check {
    path = var.tg_healthcheck_path
  }
}
resource "aws_lb_target_group_attachment" "alb_attachment" {
  target_group_arn = aws_lb_target_group.alb.arn
  target_id        = var.tg_alb_arn
  port             = 80
}
resource "aws_lb_target_group_attachment" "alb_attachment_443" {
  target_group_arn = aws_lb_target_group.alb_443.arn
  target_id        = var.tg_alb_arn
  port             = 443
}

resource "aws_lb_listener" "nlb_listner_tls" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "443"
  protocol          = "TCP"
  #certificate_arn   = var.cert_arn
  #alpn_policy       = "HTTP2Preferred"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_443.arn
  }
}
resource "aws_lb_listener" "nlb_listner" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}
