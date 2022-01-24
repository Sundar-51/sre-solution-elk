#LOAD BALANCER
resource "aws_lb" "elasticsearch" {
  name               = var.elasticsearch_load_balancer
  internal           = var.internal
  load_balancer_type = var.load_balancer_type[1]
  security_groups    = var.elasticsearch_lb_security_group_id 
  subnets            = var.public_subnets
}
#target group
resource "aws_lb_target_group" "els_target_group_cp" {
  port        = var.elasticsearch_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  
  health_check {
    protocol = "HTTP"
    port     = var.elasticsearch_port

    healthy_threshold   = 3
    unhealthy_threshold = 3

    interval = 10
  }
}
#listener
resource "aws_lb_listener" "lb_listener_cp" {
  load_balancer_arn = aws_lb.elasticsearch.arn
  port              = var.elasticsearch_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.els_target_group_cp.arn
  }
}

