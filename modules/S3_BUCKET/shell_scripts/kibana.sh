#!/bin/bash
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F\" '/region/ {print $4}')
echo $region
elasticsearch_dns_name=$(aws elbv2 describe-load-balancers --names elasticsearch-elb --query LoadBalancers[].DNSName --region $region --output text)
hostname=$(hostname -I | awk '{print $1}');
echo $elasticsearch_dns_name
echo $hostname
sed -i "s|#server.port: 5601|server.port: 5601|g" /etc/kibana/kibana.yml
sed -i "s|#server.host:|server.host:|g" /etc/kibana/kibana.yml
sed -i "s|http://localhost:9200|http://"$elasticsearch_dns_name":9200|g" /etc/kibana/kibana.yml
sed -i "s|"localhost"|"$hostname"|g" /etc/kibana/kibana.yml
sed -i "s|#elasticsearch.hosts: |elasticsearch.hosts: |g" /etc/kibana/kibana.yml