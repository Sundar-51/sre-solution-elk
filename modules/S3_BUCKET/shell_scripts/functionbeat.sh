#!/bin/bash
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F\" '/region/ {print $4}')
echo $region
elasticsearch_dns_name=$(aws elbv2 describe-load-balancers --names elasticsearch-elb --query LoadBalancers[].DNSName --region $region --output text);
kibana_dns_name=$(aws elbv2 describe-load-balancers --names kibana-lb --query LoadBalancers[].DNSName --region $region --output text);
hostname=$(hostname -I | awk '{print $1}');
t=$(date +%s)
time=$t
name="cloudwatch1"
echo $elasticsearch_dns_name
echo $kibana_dns_name
echo $hostname
echo $t
echo $time
echo $name
sed -i '24s|enabled: false|enabled: true|g' /functionbeat-7.13.1-linux-x86_64/functionbeat.yml
sed -i '60s|filter_pattern: mylog_|#filter_pattern: mylog_|g' /functionbeat-7.13.1-linux-x86_64/functionbeat.yml
sed -i '393s|#host: "localhost:5601"|host: "http://'$kibana_dns_name':5601"|g' /functionbeat-7.13.1-linux-x86_64/functionbeat.yml
sed -i '420s|"localhost:9200"|"http://'$elasticsearch_dns_name':9200"|g' /functionbeat-7.13.1-linux-x86_64/functionbeat.yml
sed -i '23s|name: cloudwatch|name: '$name'|g' /functionbeat-7.13.1-linux-x86_64/functionbeat.yml
sed -i '59s|- log_group_name: /aws/lambda/functionbeat-cloudwatch_logs|- log_group_name: /aws/apigateway/welcome|g' /functionbeat-7.13.1-linux-x86_64/functionbeat.yml
sed -i '18s|"functionbeat-deploy"|"functionbeat-deploy-'$time'"|g' /functionbeat-7.13.1-linux-x86_64/functionbeat.yml
