#logstash lb
resource "aws_lb" "logstash" {
  name               = var.logstash_load_balancer
  internal           = false
  load_balancer_type = var.load_balancer_type[2]
  subnets            = var.public_subnets
}
#load balancer target group
resource "aws_lb_target_group" "lgs_target_group_cp" {
  port        = var.logstash_port
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  
  health_check {
    protocol = "TCP"
    port     = var.logstash_port

    # NLBs required to use same healthy and unhealthy thresholds
    healthy_threshold   = 3
    unhealthy_threshold = 3

    #timeout = 10
    # Interval between health checks required to be 10 or 30
    interval = 30
  }
}
#listener
resource "aws_lb_listener" "lgs_listener_cp" {
  load_balancer_arn = aws_lb.logstash.arn
  port              = var.logstash_port
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lgs_target_group_cp.arn
  }
}
#launch configuration
resource "aws_launch_configuration" "logstash_server" {
  name          = "logstash-server"
  image_id                  = data.aws_ami.aws-linux-2.id
  instance_type = var.instance_type_logstash
  iam_instance_profile = var.instance_profile_name
  security_groups       = var.logstash_security_group_id
  key_name               =   var.key_name
  #user_data= file("./modules/LOGSTASH/logstash.sh")
  user_data = <<EOF
  #!/bin/bash
  sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
  sudo wget https://${var.aws_s3_shell_bucket_name}.s3.${var.region}.amazonaws.com/logstash.repo
  sudo chmod 777 logstash.repo
  sudo cp logstash.repo /etc/yum.repos.d/
  sudo yum install logstash-7.13.1 -y    
  sudo wget https://${var.aws_s3_shell_bucket_name}.s3.${var.region}.amazonaws.com/filebeat.conf
  sudo chmod 777 filebeat.conf
  sudo wget https://${var.aws_s3_shell_bucket_name}.s3.${var.region}.amazonaws.com/logstash.sh
  sudo chmod 777 logstash.sh
  sudo cp filebeat.conf /etc/logstash/conf.d/
  sudo cp logstash.sh /etc/logstash/conf.d/
  sudo sh /etc/logstash/conf.d/logstash.sh
  sudo systemctl start logstash
  EOF
  }
#asg
resource "aws_autoscaling_group" "logstash_asg" {
  desired_capacity   = var.no_of_logstash_nodes
  max_size           = 5
  min_size           = 1
  vpc_zone_identifier       = var.private_subnets
  launch_configuration      = aws_launch_configuration.logstash_server.name
  tag {
    key = "Name"
    value = var.logstash
    propagate_at_launch = true
  }

}
#asg attachment
resource "aws_autoscaling_attachment" "asg_attachment_logstash" {
  autoscaling_group_name = aws_autoscaling_group.logstash_asg.id
  alb_target_group_arn = aws_lb_target_group.lgs_target_group_cp.arn
}