variable "region" {
  
}
variable "vpc_count" {
  type = number
  default = 1
}
variable "map_public_ip_on_launch" {
  type = list (bool)
  default = [true, false]
}
variable "vpc_cidr" {
  
}
variable "public_subnet_cidr" {
  
}
variable "private_subnet_cidr" {
  
}
variable "public_subnet_count" {
  
}
variable "private_subnet_count" {
  
}
variable "enable_dns_hostnames" {
  type = bool
  default = false
}
variable "all_cidrs" {
  type = string
}
variable "all_cidr" {}
/*variable "ingress_ports" {
  default = [22,80,3389,3128]
}
variable "egress_ports" {
  default = [0]
}
variable "sg1" {
  type = string
  default = "instance-security-group"
}
variable "enable_dns_hostnames" {
    type = bool
    default = false
}
variable "map_public_ip_on_launch" {
    type = bool
    default = true
}
variable "map_private_ip_on_launch" {
    type = bool
    default = false
}

variable "cidr" {}*/
/*variable "network_address_space" {
  #default = "10.1.0.0/16"
  description = "Please enter the valid CIDR block for VPC"
}
variable "public_subnet1_address_space" {
  #default = "10.1.0.0/24"
  description = "Please enter the valid CIDR block for public subnet1"
}
variable "public_subnet2_address_space" {
  #default = "10.1.1.0/24"
  description = "Please enter the valid CIDR block for public subnet2"
}
variable "private_subnet1_address_space" {
  #default = "10.1.100.0/24"
  description = "Please enter the valid CIDR block for private subnet1"
}
variable "private_subnet2_address_space" {
  #default = "10.1.101.0/24"
  description = "Please enter the valid CIDR block for public subnet2"
}
variable "region" {
}
variable "enable_dns_hostnames" {
    type = bool
    default = false
}
variable "map_public_ip_on_launch" {
    type = bool
    default = true
}
variable "map_private_ip_on_launch" {
    type = bool
    default = false
}*/
variable "elasticsearch_security_group" {
}

variable "kibana_security_group" {
}
variable "logstash_security_group" {
}
variable "elasticsearch_lb_security_group" {
}

variable "kibana_lb_security_group" {
}
variable "logstash_lb_security_group" {
}

variable "heartbeat_security_group" {

}
variable "afm_security_group" {

}
variable "http_port" {
}
variable "ssh_port" { 
}
variable "elasticsearch_port" {
}
variable "kibana_port" {
}
variable "logstash_port" {
}
variable "elasticsearch_instances_ingress_ports"{
  type= list (number)
  default= [22,80,9200,5044,5601,8200]
}
variable "elasticsearch_instances_egress_ports"{
  type= list (number)
  default= [0]
}
variable "kibana_instances_ingress_ports"{
  type= list (number)
  default= [22,80,9200,5044,5601,8200]
}
variable "kibana_instances_egress_ports"{
  type= list (number)
  default= [0]
}
variable "logstash_instances_ingress_ports"{
  type= list (number)
  default= [22,80,9200,5044,5601,8200]
}
variable "logstash_instances_egress_ports"{
  type= list (number)
  default= [0]
}
variable "afm_instances_ingress_ports"{
  type= list (number)
  default= [22,80,9200,5044,5601,8200]
}
variable "afm_instances_egress_ports"{
  type= list (number)
  default= [0]
}
variable "heartbeat_instances_ingress_ports"{
  type= list (number)
  default= [22,80,9200,5044,5601,8200]
}
variable "heartbeat_instances_egress_ports"{
  type= list (number)
  default= [0]
}
variable "protocol" {
  type = list (string)
  #default = ["tcp","http","-1"]
}
/*variable "public_subnets" {

}
variable "private_subnets" {
  
}*/