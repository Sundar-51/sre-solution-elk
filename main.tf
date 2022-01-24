module "vpc" {
  source = "./modules/VPC"
  region = var.region
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_count = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  all_cidrs = var.all_cidrs
  elasticsearch_security_group = var.elasticsearch_security_group
  elasticsearch_lb_security_group= var.elasticsearch_lb_security_group
  kibana_security_group =  var.kibana_security_group
  kibana_lb_security_group=var.kibana_lb_security_group
  logstash_security_group = var.logstash_security_group
  logstash_lb_security_group= var.logstash_lb_security_group
  heartbeat_security_group = var.heartbeat_security_group
  afm_security_group = var.afm_security_group
  ssh_port = var.ssh_port
  http_port = var.http_port
  elasticsearch_port = var.elasticsearch_port
  kibana_port = var.kibana_port
  logstash_port = var.elasticsearch_port
  all_cidr = var.all_cidr
  protocol=var.protocol
}
module "iam_role"{
  source = "./modules/IAM_ROLE"
  iam_role_name = var.iam_role_name
  iam_policy_name = var.iam_policy_name
  instance_profile_name = var.instance_profile_name
  
}
module "key_pair"{
  source = "./modules/ELK_KEY"
  key_name = var.key_name
}
module "s3"{
  source = "./modules/S3_BUCKET"
  key_name = var.key_name
  aws_s3_shell_bucket_name = var.aws_s3_shell_bucket_name
  depends_on = [
    module.key_pair
  ]
}

module "elasticsearch_master" {
  source = "./modules/ELASTICSEARCH"
  elasticsearch_load_balancer = var.elasticsearch_load_balancer
  vpc_id = module.vpc.vpc_id
  load_balancer_type = var.load_balancer_type
  elasticsearch_security_group = module.vpc.elasticsearch_security_group
  elasticsearch_security_group_id = module.vpc.elasticsearch_security_group_id
  elasticsearch_lb_security_group = module.vpc.elasticsearch_lb_security_group
  elasticsearch_lb_security_group_id = module.vpc.elasticsearch_lb_security_group_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  elasticsearch_port = var.elasticsearch_port
  instance_profile_name = var.instance_profile_name
  key_name = var.key_name
  instance_type_elasticsearch_master = var.instance_type_elasticsearch_master
  no_of_elasticsearch_master_nodes = var.no_of_elasticsearch_master_nodes
  #elasticsearch_master = var.elasticsearch_master
  aws_s3_shell_bucket_name = var.aws_s3_shell_bucket_name
  region = var.region
  els_master = var.els_master
  depends_on = [
    module.vpc, module.key_pair, module.s3
  ]
}
module "elasticsearch_slave" {
  source = "./modules/ELASTICSEARCH_SLAVE"
  vpc_id = module.vpc.vpc_id
  instance_type_elasticsearch_slave = var.instance_type_elasticsearch_slave
  elasticsearch_security_group = module.vpc.elasticsearch_security_group
  elasticsearch_security_group_id = module.vpc.elasticsearch_security_group_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  elasticsearch_port = var.elasticsearch_port
  instance_profile_name = var.instance_profile_name
  key_name = var.key_name
  no_of_elasticsearch_slave_nodes = var.no_of_elasticsearch_slave_nodes
  els_slave = var.els_slave
  aws_s3_shell_bucket_name = var.aws_s3_shell_bucket_name
  region = var.region
  depends_on = [
    module.elasticsearch_master
  ]
}
module "kibana" {
  source = "./modules/KIBANA"
  vpc_id = module.vpc.vpc_id
  kibana_load_balancer = var.kibana_load_balancer
  load_balancer_type= var.load_balancer_type
  instance_type_kibana = var.instance_type_kibana
  kibana_security_group = module.vpc.kibana_security_group
  kibana_lb_security_group = module.vpc.kibana_lb_security_group
  kibana_security_group_id = module.vpc.kibana_security_group_id
  kibana_lb_security_group_id = module.vpc.kibana_lb_security_group_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  kibana_port = var.kibana_port
  instance_profile_name = var.instance_profile_name
  key_name = var.key_name
  no_of_kibana_nodes = var.no_of_kibana_nodes
  kibana = var.kibana
  aws_s3_shell_bucket_name = var.aws_s3_shell_bucket_name
  region = var.region
  depends_on = [
    module.elasticsearch_slave
  ]
}
module "logstash" {
  source = "./modules/LOGSTASH"
  vpc_id = module.vpc.vpc_id
  logstash_load_balancer = var.logstash_load_balancer
  load_balancer_type= var.load_balancer_type
  instance_type_logstash = var.instance_type_logstash
  logstash_security_group = module.vpc.logstash_security_group
  logstash_lb_security_group = module.vpc.logstash_lb_security_group
  logstash_security_group_id = module.vpc.logstash_security_group_id
  logstash_lb_security_group_id = module.vpc.logstash_lb_security_group_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  logstash_port = var.logstash_port
  instance_profile_name = var.instance_profile_name
  key_name = var.key_name
  no_of_logstash_nodes = var.no_of_logstash_nodes
  logstash = var.logstash
  aws_s3_shell_bucket_name = var.aws_s3_shell_bucket_name
  region = var.region
  depends_on = [
    module.kibana
  ]
}
module "heartbeat" {
  source = "./modules/HEARTBEAT"
  vpc_id = module.vpc.vpc_id
  instance_type_heartbeat = var.instance_type_heartbeat
  heartbeat_security_group = module.vpc.heartbeat_security_group
  heartbeat_security_group_id = module.vpc.heartbeat_security_group_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  heartbeat = var.heartbeat
  key_name = var.key_name
  aws_s3_shell_bucket_name = var.aws_s3_shell_bucket_name
  region = var.region
  instance_profile_name = var.instance_profile_name
  depends_on = [
    module.kibana
  ]
}
module "afm" {
  source= "./modules/AFM"
  vpc_id = module.vpc.vpc_id
  instance_type_afm = var.instance_type_afm
  afm_security_group = module.vpc.afm_security_group
  afm_security_group_id = module.vpc.afm_security_group_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  afm = var.afm
  key_name = var.key_name
  afm_iam_role_name = var.afm_iam_role_name
  afm_iam_policy_name = var.afm_iam_policy_name
  iam_metricbeat_policy_name = var.iam_metricbeat_policy_name
  iam_function_beat_policy_name = var.iam_function_beat_policy_name
  #iam_trust_policy_name = var.iam_trust_policy_name
  afm_instance_profile_name = var.afm_instance_profile_name
  aws_s3_shell_bucket_name = var.aws_s3_shell_bucket_name
  region = var.region
  depends_on = [
    module.kibana
  ]
}