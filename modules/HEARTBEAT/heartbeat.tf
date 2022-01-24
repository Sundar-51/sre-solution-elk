#launch configuration
resource "aws_launch_configuration" "heartbeat_server" {
  name          = "heartbeat-server"
  image_id                  = data.aws_ami.aws-linux-2.id
  instance_type = var.instance_type_heartbeat
  iam_instance_profile = var.instance_profile_name
  security_groups       = var.heartbeat_security_group_id
  key_name               =   var.key_name
  #user_data= file("./modules/HEARTBEAT/heartbeat.sh")
  user_data = <<EOF
  #!/bin/bash
  sudo curl -L -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-7.13.1-linux-x86_64.tar.gz
  sudo tar xzvf heartbeat-7.13.1-linux-x86_64.tar.gz
  sudo wget https://${var.aws_s3_shell_bucket_name}.s3.${var.region}.amazonaws.com/heartbeat.sh
  sudo chmod 777 heartbeat.sh
  sudo cp heartbeat.sh /heartbeat-7.13.1-linux-x86_64/
  sudo sh /heartbeat-7.13.1-linux-x86_64/heartbeat.sh
  cd /heartbeat-7.13.1-linux-x86_64/
  sudo heartbeat setup -e
  sudo chown root heartbeat.yml
  sudo ./heartbeat -e
  EOF
  }
#asg
resource "aws_autoscaling_group" "heartbeat_asg" {
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier       = var.private_subnets
  launch_configuration      = aws_launch_configuration.heartbeat_server.name
  tag {
    key = "Name"
    value = var.heartbeat
    propagate_at_launch = true
  }

}
