#launch configuration
resource "aws_launch_configuration" "els_slave1" {
  name          = "els-slave"
  image_id        = data.aws_ami.aws-linux-2.id
  instance_type = var.instance_type_elasticsearch_slave
  iam_instance_profile = var.instance_profile_name
  security_groups       = var.elasticsearch_security_group_id
  key_name               =   var.key_name
  #user_data= file("./modules/ELASTICSEARCH_SLAVE/elasticsearch_slave_3subnets.sh")
  user_data = <<EOF
  #!/bin/bash
  sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.13.1-x86_64.rpm
  sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.13.1-x86_64.rpm.sha512
  sudo rpm --install elasticsearch-7.13.1-x86_64.rpm
  sudo systemctl daemon-reload
  sudo systemctl enable elasticsearch.service
  sudo wget https://${var.aws_s3_shell_bucket_name}.s3.${var.region}.amazonaws.com/elasticsearch_slave2.sh
  sudo chmod 777 elasticsearch_slave2.sh
  sudo cp elasticsearch_slave2.sh /etc/elasticsearch
  sudo sh /etc/elasticsearch/elasticsearch_slave2.sh
  sudo systemctl restart elasticsearch
  EOF
  count = var.private_subnets != 2 ? 1 : 0
  }
#AUTO SCALING GROUP INSTANCES
resource "aws_autoscaling_group" "ELSlave1" {
  desired_capacity   = var.no_of_elasticsearch_slave_nodes
  max_size           = 5
  min_size           = 1
  vpc_zone_identifier       = var.private_subnets
  launch_configuration      = aws_launch_configuration.els_slave1[0].name
  tag {
    key = "Name"
    value = var.els_slave
    propagate_at_launch = true
  }
  count = var.private_subnets != 2 ? 1 : 0
}