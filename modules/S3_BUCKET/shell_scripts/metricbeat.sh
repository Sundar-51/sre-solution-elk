#!/bin/bash
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F\" '/region/ {print $4}')
echo $region
elasticsearch_dns_name=$(aws elbv2 describe-load-balancers --names elasticsearch-elb --query LoadBalancers[].DNSName --region $region --output text);
kibana_dns_name=$(aws elbv2 describe-load-balancers --names kibana-lb --query LoadBalancers[].DNSName --region $region --output text);
hostname=$(hostname -I | awk '{print $1}');
echo $elasticsearch_dns_name
echo $kibana_dns_name
echo $hostname
sed -i '17s|reload.enabled: false|reload.enabled: true|g' /metricbeat-7.13.1-linux-x86_64/metricbeat.yml
sed -i '67s|#host: "localhost:5601"|host: "http://'$kibana_dns_name':5601"|g' /metricbeat-7.13.1-linux-x86_64/metricbeat.yml
sed -i '94s|"localhost:9200"|"http://'$elasticsearch_dns_name':9200"|g' /metricbeat-7.13.1-linux-x86_64/metricbeat.yml
