env = "prod"
cluster_name = "prod-centraleks"
cluster_version = "1.27"
node_ami_version = "1.27.9-20240202"

vpc_id = "vpc-0961b3590effc4d64"
vpc_cidr = "10.23.0.0/16"

privatesubnet_cidrs = ["10.23.172.0/22","10.23.176.0/22","10.23.180.0/22","10.23.184.0/26","10.23.184.64/26","10.23.184.128/26"]
rt_cidr_blocks    = ["10.22.16.0/22", "10.22.0.0/20", "10.10.0.0/16", "0.0.0.0/0", "10.19.0.0/16"]
transit_gw_id = "tgw-06ba356a5b17c4b84"
inviz_sg_id = "sg-0ba53a3c92445841f"

cluster_sg_add_rules_cidr = ["10.23.0.0/16", "10.19.0.0/16"]
#cluster_sg_add_rules = "10.21.0.0/16,10.19.0.0/16"

coredns_version = "v1.9.3-eksbuild.11"
kube_proxy_version = "v1.27.8-eksbuild.4"
vpc_cni_version = "v1.15.1-eksbuild.1"
ebs_csi_version = "v1.24.1-eksbuild.1"

disk_size = "50"
key_name = "prdsapkey"

min_size_workers_1 = "1"
max_size_workers_1 = "20"
desired_size_workers_1 = "6"
cap_type_workers_1 = "ON_DEMAND"
instance_types_workers_1 = ["m6a.2xlarge"]
node_ami_version_workers_1 = "1.27.9-20240202"
ami_type_workers_1 = "AL2_x86_64"

### ELastic worker node
min_size_elastic_worker = "0"
max_size_elastic_worker = "6"
desired_size_elastic_worker = "3"
instance_types_elastic_worker =  ["t3.xlarge"]
cap_type_elastic_worker =  "ON_DEMAND"

### MTELastic worker node
min_size_mtelastic_worker = "0"
max_size_mtelastic_worker = "10"
desired_size_mtelastic_worker = "5"
instance_types_mtelastic_worker =  ["m6a.2xlarge"]
cap_type_mtelastic_worker =  "ON_DEMAND"

### Monitoring worker node
min_size_monitoring_worker = "0"
max_size_monitoring_worker = "5"
desired_size_monitoring_worker = "3"
instance_types_monitoring_worker =  ["t3.xlarge"]
cap_type_monitoring_worker =  "ON_DEMAND"

#centraleks_cluster_autoscaler_sa = "autoscaler-aws-cluster-autoscaler"
centraleks_cluster_autoscaler_image_tag = "v1.27.5"
centraleks_alb_controller_image_tag = "v2.4.5"
centraleks_metrics_server_image_tag = "v0.6.2"
centraleks_efs_csi_image_tag = "v1.4.8"

#velero
velero_req = "no"
vel_s3_bkt_arns =[]

auth_roles = [
  {
    rolearn  = "arn:aws:iam::080542245903:role/Inviz-EksKubectlRole"
    username = "build"
    groups   = ["system:masters"]
  },
  {
    rolearn  = "arn:aws:iam::080542245903:role/Devops_L3_Role"
    username = "Devops_L3_Role"
    groups   = ["eks-console-dashboard-full-access-group"]
  },
  {
    rolearn  = "arn:aws:iam::080542245903:role/TulAdminAccess"
    username = "tuladminaccess"
    groups   = ["system:masters"]
  }
]

auth_users = [
  {
    userarn = "arn:aws:iam::822771609266:user/srajavnsh@tataunistore.com"
    username = "srajavnsh@tataunistore.com"
    groups = ["system:masters"]
  },
  {
    userarn = "arn:aws:iam::822771609266:user/omankame_t@tataunistore.com"
    username = "omankame_t@tataunistore.com"
    groups = ["system:masters"]
  },
  {
    userarn = "arn:aws:iam::822771609266:user/sredlapalli_t@tataunistore.com"
    username = "sredlapalli_t@tataunistore.com"
    groups = ["system:masters"]
  },
  {
    userarn = "arn:aws:iam::822771609266:user/nsingh2_t@tataunistore.com"
    username = "nsingh2_t@tataunistore.com"
    groups = ["system:masters"]
  }
]

approver_name = "Ruthraih_Thulasi"

## EFS Settings
efs_token = "efs-centraleks"
efs_token_2 = "efs-2-centraleks"
efs_token_3 = "efs-3-centraleks"
efs_widget_req = "yes"
efs_datascience_req = "no"

api_gw_req = "yes" #change to anything otherthan 'yes' if api gateway not required in that environment
api_gw_nlb_name = "centraleks-mt-apps-apigw"
api_gw_nlb_tg_name = "centraleks-mt-apps-alb"
tg_name_tls = "centraleks-mt-apps-alb-tls"
api_gw_tg_healthcheck_path = "/crm-integration/actuator/health"
tg_alb_arn = "arn:aws:elasticloadbalancing:ap-south-1:080542245903:loadbalancer/app/k8s-mtapps-097ee77df2/aba350345f527143"
cert_arn = "arn:aws:iam::080542245903:server-certificate/2024_Wildcard_TataCliq_Certificate"

api_gw_name = "martech-gw"
api_gw_resource_path = "sf"
api_key_name = "crm_key"
api_key_value = "AN84302HAM53SI89NG1OQH9O2NG1617N95"
crm_usage_plan_name = "crm_usage_plan"
vpc_link_name = "centraleks-mt-apps-nlb"
api_path = "crm-integration/api/encrypt"
stage_name = "crm"
custom_domain_apigw = "crm-martech.tatacliq.com"
zone_domain = "tatacliq.com"
acm_cert_arn = "arn:aws:acm:ap-south-1:080542245903:certificate/9d5a8f39-73f4-405d-8ef7-55fe50f1a646"
crm_enc_base_path = "crm/v1/enc"

###Elasticache Redis

martech_elasticache_subnetgroup_name = "martech-redis-cache-subnet"
martech_elasticache_id = "martech-redis-prod"
martech_elasticache_nodetype = "cache.r5.large"
