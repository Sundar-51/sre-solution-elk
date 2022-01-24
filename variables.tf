################################################################################
# VARIABLES
################################################################################
variable "region" {
  type=string
  description = "Please enter the valid AWS region for deployment:"
}

#S3-MODULE
variable "aws_s3_shell_bucket_name" {
  type = string
  #default = "aws-s3-shell-bucket"
}
variable "key_name" {
  type = string
}
#VPC-MODULE
variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = list (string)
}
variable "private_subnet_cidr" {
  type = list (string)
}
variable "public_subnet_count" {
  type = number
}
variable "private_subnet_count" {
  type = number
}
variable "all_cidrs" {
  type = string
}
variable "protocol" {
  type = list (string)
}
variable "elasticsearch_security_group"{
  type=string
  #default = aws_security_group.elb-sg.id
}
variable "elasticsearch_lb_security_group"{
  type=string
  #default = aws_security_group.elb-sg.id
}
variable "kibana_security_group" {
  type=string
}
variable "kibana_lb_security_group" {
  type=string
}
variable "logstash_security_group" {
  type=string
}
variable "logstash_lb_security_group" {
  type=string
}
variable "heartbeat_security_group" {
  type=string
}
variable "afm_security_group" {
  type=string
}
variable "http_port" {
  type=number
}
variable "ssh_port" {
  type=number
}
variable "elasticsearch_port" {
  type=number
}
variable "kibana_port" {
  type=number
}
variable "logstash_port" {
  type=number
}
variable "iam_role_name" {
  type = string 
}

variable "iam_policy_name" {
  type = string 
}
variable "instance_profile_name" {
  type = string 
}
variable "afm_iam_role_name" {
  type = string
}
variable "afm_iam_policy_name" {
  type = string
}
variable "iam_metricbeat_policy_name" {
  type = string
}
variable "iam_function_beat_policy_name" {
  type = string
}
variable "afm_instance_profile_name" {
  type = string
}

variable "elasticsearch_load_balancer" {
  type = string
}

variable "kibana_load_balancer" {
  type = string
}
variable "logstash_load_balancer" {
  type = string
}
variable "instance_type_elasticsearch_master" {
  type= string
  description = "Please enter the type of EC2 instance for Elasticsearch master instances:" 
}
variable "no_of_elasticsearch_master_nodes" {
  type = number
  description = "Please enter the number of EC2 instance for Elasticsearch master configuration:"
}
variable "els_master" {
  type = string
}
variable "els_slave" {
  type= string
}
variable "instance_type_elasticsearch_slave" {
  type= string
  description = "Please enter the type of EC2 instance for Elasticsearch slave instances:"
}
variable "no_of_elasticsearch_slave_nodes" {
  type = number
  description = "Please enter the number of EC2 instance for Elasticsearch slave configuration:"
}
variable "instance_type_kibana" {
  type = string
  description = "Please enter the type of EC2 instance for Kibana instances:"
}


variable "no_of_kibana_nodes" {
  type = number
  description = "Please enter the number of EC2 instance for Kibana configuration:"
}
variable "kibana" {
  type = string

}
variable "instance_type_logstash" {
  type = string
  description = "Please enter the type of EC2 instance for Logstash:"
}


variable "no_of_logstash_nodes" {
  type = number
  description = "Please enter the number of EC2 instance for Logstash configuration:"
}
variable "logstash" {
  type = string
}
variable "instance_type_heartbeat" {
  type = string
  default = "t2.medium"
}

variable "heartbeat" {
    type = string
}
variable "instance_type_afm" {
  type = string
  default = "t2.medium"
}

variable "afm" {
  type = string
}
variable "load_balancer_type"{
  type= list
  #default= ["classic", "application", "network"]
}
variable "all_cidr" {
    type = list (string)
    default = ["0.0.0.0/0"]
}
