#launch configuration
resource "aws_launch_configuration" "afm_server" {
  name          = "AFM-server"
  image_id                  = data.aws_ami.aws-linux-2.id
  instance_type = var.instance_type_afm
  iam_instance_profile = var.afm_instance_profile_name
  security_groups       = var.afm_security_group_id
  key_name               =   var.key_name
  #user_data= file("./modules/AFM/afm.sh")
  user_data = <<EOF
  #!/bin/bash
  sudo curl -L -O https://artifacts.elastic.co/downloads/apm-server/apm-server-7.13.1-linux-x86_64.tar.gz
  sudo tar xzvf apm-server-7.13.1-linux-x86_64.tar.gz
  sudo wget https://${var.aws_s3_shell_bucket_name}.s3.${var.region}.amazonaws.com/apm.sh
  sudo chmod 777 apm.sh
  sudo cp apm.sh /apm-server-7.13.1-linux-x86_64/
  sudo sh /apm-server-7.13.1-linux-x86_64/apm.sh
  sudo curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.13.1-linux-x86_64.tar.gz
  sudo tar xzvf metricbeat-7.13.1-linux-x86_64.tar.gz
  sudo wget https://${var.aws_s3_shell_bucket_name}.s3.${var.region}.amazonaws.com/metricbeat.sh
  sudo chmod 777 metricbeat.sh
  sudo cp metricbeat.sh /metricbeat-7.13.1-linux-x86_64/
  sudo sh /metricbeat-7.13.1-linux-x86_64/metricbeat.sh
  sudo curl -L -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-7.13.1-linux-x86_64.tar.gz
  sudo tar xzvf functionbeat-7.13.1-linux-x86_64.tar.gz
  sudo wget https://${var.aws_s3_shell_bucket_name}.s3.${var.region}.amazonaws.com/functionbeat.sh
  sudo chmod 777 functionbeat.sh
  sudo cp functionbeat.sh /functionbeat-7.13.1-linux-x86_64/
  sudo sh /functionbeat-7.13.1-linux-x86_64/functionbeat.sh
  cd /apm-server-7.13.1-linux-x86_64/
  sudo nohup ./apm-server -e &
  cd /metricbeat-7.13.1-linux-x86_64/
  sudo ./metricbeat modules enable aws
  sudo nohup ./metricbeat setup -e &
  sudo chown root metricbeat.yml
  sudo chown root modules.d/aws.yml
  sudo nohup ./metricbeat -e &
  cd /functionbeat-7.13.1-linux-x86_64/
  sudo ./functionbeat setup -e 
  sudo nohup ./functionbeat -v -e -d "*" deploy cloudwatch1 -e &
  EOF
  }
#asg
resource "aws_autoscaling_group" "afm_asg" {
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier       = var.public_subnets
  launch_configuration      = aws_launch_configuration.afm_server.name
  tag {
    key = "Name"
    value = var.afm
    propagate_at_launch = true
  }

}
