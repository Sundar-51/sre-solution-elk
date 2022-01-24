/*output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "sh_scripts" {
  value = module.s3.sh_files
  #"https://${var.elk}.s3.${var.region}.amazonaws.com/elasticsearch_master.sh"
}*/
output "elasticsearch_lb_dns_name" {
  value = module.elasticsearch_master.elasticsearch_lb_dns_name
}
output "kibana_lb_dns_name" {
  value = module.kibana.kibana_lb_dns_name
}
output "logstash_lb_dns_name" {
  value = module.logstash.logstash_lb_dns_name
}