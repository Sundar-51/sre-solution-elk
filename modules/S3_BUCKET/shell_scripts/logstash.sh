#!/bin/bash
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F\" '/region/ {print $4}')
echo $region
elasticsearch_dns_name=$(aws elbv2 describe-load-balancers --names elasticsearch-elb --query LoadBalancers[].DNSName --region $region --output text);
echo $elasticsearch_dns_name
sed -i 's|hosts => ""|hosts => "http://'$elasticsearch_dns_name'"|g' /etc/logstash/conf.d/filebeat.conf
