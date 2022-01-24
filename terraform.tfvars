elasticsearch_security_group = "elasticsearch_security_group"
elasticsearch_lb_security_group = "elasticsearch_lb_security_group"
kibana_security_group = "kibana_security_group"
kibana_lb_security_group = "kibana_lb_security_group"
logstash_security_group = "logstash_security_group"
logstash_lb_security_group = "logstash_lb_security_group"
heartbeat_security_group = "heartbeat_security_group"
afm_security_group = "afm_security_group"
http_port = 80  
ssh_port = 22 
elasticsearch_port = 9200
kibana_port = 5601
logstash_port = 5044 
protocol=  ["tcp","http","-1"]

iam_role_name = "ec2-read-only-role"
iam_policy_name = "ec2-read-only-policy"
instance_profile_name = "ec2-instance-profile"

afm_iam_role_name = "afm-iam-role-name"
afm_iam_policy_name = "afm-iam-policy-name"
iam_metricbeat_policy_name = "iam-metricbeat-policy-name"
iam_function_beat_policy_name = "iam-function-beat-policy-name"
afm_instance_profile_name = "afm-instance-profile-name"
#iam_trust_policy_name = "iam-trust-policy-name"

key_name = "elk_key_pair.pem"
elasticsearch_load_balancer = "elasticsearch-elb"

els_master = "ElasticSearch-Master"

els_slave = "ElasticSearch-Slave"

kibana_load_balancer = "kibana-lb"

kibana = "kibana-server"

logstash_load_balancer = "logstash-lb"

logstash = "logstash-server"

heartbeat = "heartbeat-server"

afm = "afm-server"

load_balancer_type=["classic", "application", "network"]

region = "us-west-1"
vpc_cidr = "10.1.0.0/16"
public_subnet_cidr = ["10.1.0.0/24", "10.1.1.0/24"]
private_subnet_cidr = ["10.1.100.0/24", "10.1.101.0/24"]
all_cidrs = "0.0.0.0/0"
instance_type_elasticsearch_master = "t2.medium"
instance_type_elasticsearch_slave = "t2.medium"
instance_type_kibana = "t2.medium"
instance_type_logstash = "t2.medium"
no_of_kibana_nodes = 2
no_of_logstash_nodes = 2
no_of_elasticsearch_master_nodes = 2
no_of_elasticsearch_slave_nodes = 2
aws_s3_shell_bucket_name = "aws-s3-shell-bucket"