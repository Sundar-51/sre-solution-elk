output "vpc_id" {
  value = aws_vpc.vpc[0].id
}
output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}
output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}
output "elasticsearch_security_group" {
  value = aws_security_group.el-sg
}
output "elasticsearch_lb_security_group" {
  value = aws_security_group.el-lb-sg
}
output "logstash_security_group" {
  value = aws_security_group.logstash-sg
}
output "logstash_lb_security_group" {
  value = aws_security_group.logstash-lb-sg
}
output "kibana_security_group" {
  value = aws_security_group.kibana-sg
}
output "kibana_lb_security_group" {
  value = aws_security_group.kibana-lb-sg
}
output "heartbeat_security_group" {
  value = aws_security_group.heartbeat-sg
}
output "afm_security_group" {
  value = aws_security_group.afm-sg
}
output "elasticsearch_security_group_id" {
  value = aws_security_group.el-sg[*].id
}
output "elasticsearch_lb_security_group_id" {
  value = aws_security_group.el-lb-sg[*].id
}
output "kibana_security_group_id" {
  value = aws_security_group.kibana-sg[*].id
}
output "kibana_lb_security_group_id" {
  value = aws_security_group.kibana-lb-sg[*].id
}
output "logstash_security_group_id" {
  value = aws_security_group.logstash-sg[*].id
}
output "logstash_lb_security_group_id" {
  value = aws_security_group.logstash-lb-sg[*].id
}
output "heartbeat_security_group_id" {
  value = aws_security_group.heartbeat-sg[*].id
}
output "afm_security_group_id" {
  value = aws_security_group.afm-sg[*].id
}
/*output "public_subnets" {
  value = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}
output "private_subnets" {
  value = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}*/