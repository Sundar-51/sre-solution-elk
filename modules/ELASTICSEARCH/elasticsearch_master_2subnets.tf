resource "aws_launch_configuration" "els_master" {
  name          = "els-master"
  image_id                  = data.aws_ami.aws-linux-2.id
  instance_type = var.instance_type_elasticsearch_master
  iam_instance_profile = var.instance_profile_name
  security_groups       = var.elasticsearch_security_group_id
  key_name               =   var.key_name
  #user_data= file("./modules/ELASTICSEARCH/elasticsearch_master_2subnets.sh")
  user_data = <<EOF
  #!/bin/bash
  sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.13.1-x86_64.rpm
  sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.13.1-x86_64.rpm.sha512
  sudo rpm --install elasticsearch-7.13.1-x86_64.rpm
  sudo systemctl daemon-reload
  sudo systemctl enable elasticsearch.service
  sudo wget https://${var.aws_s3_shell_bucket_name}.s3.${var.region}.amazonaws.com/elasticsearch_master.sh
  sudo chmod 777 elasticsearch_master.sh
  sudo cp elasticsearch_master.sh /etc/elasticsearch
  sudo sh /etc/elasticsearch/elasticsearch_master.sh
  sudo systemctl restart elasticsearch
  EOF
  count = var.public_subnets == 2 ? 1 : 0
  }
resource "aws_autoscaling_group" "ELS-Master" {
  desired_capacity   = var.no_of_elasticsearch_master_nodes
  max_size           = 5
  min_size           = 1
  vpc_zone_identifier       = var.public_subnets
  launch_configuration      = aws_launch_configuration.els_master[0].name
  tag {
    key = "Name"
    value = var.els_master
    propagate_at_launch = true
  }
  count = var.public_subnets == 2 ? 1 : 0
}
resource "aws_autoscaling_attachment" "asg_attachment_els_master" {
  autoscaling_group_name = aws_autoscaling_group.ELS-Master[0].id
  alb_target_group_arn = aws_lb_target_group.els_target_group_cp.arn
  count = var.public_subnets == 2 ? 1 : 0
}
