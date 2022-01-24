#!/bin/bash
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F\" '/region/ {print $4}')
echo $region
elasticsearch_dns_name=$(aws elbv2 describe-load-balancers --names elasticsearch-elb --query LoadBalancers[].DNSName --region $region --output text);
kibana_dns_name=$(aws elbv2 describe-load-balancers --names kibana-lb --query LoadBalancers[].DNSName --region $region --output text);
hostname=$(hostname -I | awk '{print $1}');
echo $elasticsearch_dns_name
echo $hostname
sed -i 's|host: "localhost:8200"|host: "'$hostname':8200"|g' /apm-server-7.13.1-linux-x86_64/apm-server.yml
sed -i 's|#max_connections: 0|max_connections: 0|g' /apm-server-7.13.1-linux-x86_64/apm-server.yml
sed -i 's|#kibana:|kibana:|g' /apm-server-7.13.1-linux-x86_64/apm-server.yml
sed -i '283s|#enabled: false|enabled: true|g' /apm-server-7.13.1-linux-x86_64/apm-server.yml
sed -i '288s|#host: "localhost:5601"|host: "'$kibana_dns_name':5601"|g' /apm-server-7.13.1-linux-x86_64/apm-server.yml
sed -i '543s|"localhost:9200"|"'$elasticsearch_dns_name':9200"|g' /apm-server-7.13.1-linux-x86_64/apm-server.yml

