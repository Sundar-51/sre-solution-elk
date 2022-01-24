#!/bin/bash
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F\" '/region/ {print $4}')
echo $region
master1=$(aws ec2 describe-instances --query "Reservations[0].Instances[0].PrivateIpAddress" --filters "Name=tag-value,Values=ElasticSearch-Master" "Name=instance-state-name,Values=running" --region $region --output=text);
master2=$(aws ec2 describe-instances --query "Reservations[1].Instances[0].PrivateIpAddress" --filters "Name=tag-value,Values=ElasticSearch-Master" "Name=instance-state-name,Values=running" --region $region --output=text);
master3=$(aws ec2 describe-instances --query "Reservations[2].Instances[0].PrivateIpAddress" --filters "Name=tag-value,Values=ElasticSearch-Master" "Name=instance-state-name,Values=running" --region $region --output=text);
master4=$(aws ec2 describe-instances --query "Reservations[0].Instances[1].PrivateIpAddress" --filters "Name=tag-value,Values=ElasticSearch-Master" "Name=instance-state-name,Values=running" --region $region --output=text);
hostname=$(hostname -I | awk '{print $1}');
name=$(aws ec2 describe-instances --instance-id $(curl -s http://169.254.169.254/latest/meta-data/instance-id) --query "Reservations[*].Instances[*].Tags[?Key=='Name'].Value" --region $region --output=text);
count=$(aws ec2 describe-instances --filters "Name=tag-value,Values=ElasticSearch-Master" --query 'Reservations[*].Instances[*].[InstanceId]' "Name=instance-state-name,Values=running" --region $region --output text | wc -l);
echo $master1
echo $master2
echo $master3
echo $master4
echo $count
echo $name
sed -i "s|#cluster.name: my-application|cluster.name: els-demo|g" /etc/elasticsearch/elasticsearch.yml
sed -i "s|#node.name: node-1|node.name: Master|g" /etc/elasticsearch/elasticsearch.yml
sed -i "s|#network.host: 192.168.0.1|network.host: "$hostname"|g" /etc/elasticsearch/elasticsearch.yml
sed -i 's|#cluster.in|cluster.in|g' /etc/elasticsearch/elasticsearch.yml
sed -i '$ a node.master: true' /etc/elasticsearch/elasticsearch.yml
sed -i 's|## -Xms4g|-Xms2g|g' /etc/elasticsearch/jvm.options
sed -i 's|## -Xmx4g|-Xmx2g|g' /etc/elasticsearch/jvm.options
if [ $count == 2 ];
then
    sed -i 's|"host1", "host2"|"'"$master1"'", "'"$master2"'"|g' /etc/elasticsearch/elasticsearch.yml
	sed -i 's|"node-1", "node-2"|"'"$master1"'", "'"$master2"'"|g' /etc/elasticsearch/elasticsearch.yml
elif [ $count==3 ];
then
	sed -i 's|"host1", "host2"|"'"$master1"'", "'"$master2"'", "'"$master3"'"|g' /etc/elasticsearch/elasticsearch.yml
	sed -i 's|"node-1", "node-2"|"'"$master1"'", "'"$master2"'", "'"$master3"'"|g' /etc/elasticsearch/elasticsearch.yml
else 
    sed -i 's|"host1", "host2"|"'"$master1"'", "'"$master2"'", "'"$master3"'"|g' /etc/elasticsearch/elasticsearch.yml
	sed -i 's|"node-1", "node-2"|"'"$master1"'", "'"$master2"'", "'"$master3"'"|g' /etc/elasticsearch/elasticsearch.yml
fi
sed -i 's|#discovery.seed_hosts:|discovery.seed_hosts:|g' /etc/elasticsearch/elasticsearch.yml