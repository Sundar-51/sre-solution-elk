#!/bin/bash
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F\" '/region/ {print $4}')
echo $region
a=$(aws ssm get-parameters --name "webapp" --region $region --query Parameters[*].Value[] --output text);
b=$(aws ssm get-parameters --name "Eshop" --region $region --query Parameters[*].Value[] --output text);
c=$(aws ssm get-parameters --name "batch-app" --region $region --query Parameters[*].Value[] --output text);
d=$(aws ssm get-parameters --name "batch-app-db" --region $region --query Parameters[*].Value[] --output text);
e=$(aws ssm get-parameters --name "batchapp" --region $region --query Parameters[*].Value[] --output text);
elasticsearch_dns_name=$(aws elbv2 describe-load-balancers --names elasticsearch-elb --query LoadBalancers[].DNSName --region $region --output text);
echo $a
echo $b
echo $c
echo $d
echo $e
echo $elasticsearch_dns_name
sed -i 's|enabled: false|enabled: true|g' /heartbeat-7.13.1-linux-x86_64/heartbeat.yml
sed -i 's|"http://localhost:9200"|"'$a'", "'$b'", "'$c'", "'$d'"|g' /heartbeat-7.13.1-linux-x86_64/heartbeat.yml
sed -i 's|localhost:9200|'$elasticsearch_dns_name':9200|g' /heartbeat-7.13.1-linux-x86_64/heartbeat.yml