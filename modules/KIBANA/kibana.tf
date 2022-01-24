#load balancer
resource "aws_lb" "kibana" {
  name               = var.kibana_load_balancer
  internal           = false
  load_balancer_type = var.load_balancer_type[1]
  security_groups    = var.kibana_lb_security_group_id
  subnets            = var.public_subnets
}
#target group
resource "aws_lb_target_group" "kibana_target_group_cp" {
  port        = var.kibana_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  
  health_check {
    protocol = "HTTP"
    port     = var.kibana_port
    matcher     = "200,302"  
    healthy_threshold   = 3
    unhealthy_threshold = 3

    timeout = 10
    interval = 30
  }
}

#LISTENER
resource "aws_lb_listener" "kibana_listener_cp" {
  load_balancer_arn = aws_lb.kibana.arn
  port              = var.kibana_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kibana_target_group_cp.arn
  }
}
#launch configuration
resource "aws_launch_configuration" "kibana_server" {
  name          = "kibana-server"
  image_id                  = data.aws_ami.aws-linux-2.id
  instance_type = var.instance_type_kibana
  iam_instance_profile = var.instance_profile_name
  security_groups       = var.kibana_security_group_id
  key_name               =   var.key_name
  #user_data= file("./modules/KIBANA/kibana.sh")
  user_data = <<EOF
  #!/bin/bash
  sudo wget https://artifacts.elastic.co/downloads/kibana/kibana-7.13.1-x86_64.rpm
  sudo rpm --install kibana-7.13.1-x86_64.rpm
  sudo chkconfig --add kibana
  sudo wget https://${var.aws_s3_shell_bucket_name}.s3.${var.region}.amazonaws.com/kibana.sh
  sudo chmod 777 kibana.sh
  sudo cp kibana.sh /etc/kibana
  sudo sh /etc/kibana/kibana.sh
  sudo systemctl restart kibana
  EOF
  }
#AUTO SCALING GROUP INSTANCES
resource "aws_autoscaling_group" "kibana_asg" {
  desired_capacity   = var.no_of_kibana_nodes
  max_size           = 5
  min_size           = 1
  vpc_zone_identifier       = var.private_subnets
  launch_configuration      = aws_launch_configuration.kibana_server.name
  tag {
    key = "Name"
    value = var.kibana
    propagate_at_launch = true
  }
}
#asg attachment
resource "aws_autoscaling_attachment" "asg_attachment_kibana" {
  autoscaling_group_name = aws_autoscaling_group.kibana_asg.id
  alb_target_group_arn = aws_lb_target_group.kibana_target_group_cp.arn
}
