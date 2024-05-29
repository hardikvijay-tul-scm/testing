variable "aws_profile" {
  type = string
  default = "default"  
}

variable "aws_region" {
  type = string
  default = "ap-south-1"  
}

variable "env" {
  
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type = string
}

variable "cluster_version" {
  type = string 
}

variable "node_ami_version" {
  
}

variable "vpc_id" {
  type = string  
}

variable "vpc_cidr" {
  type = string
}

variable "transit_gw_id" {
  type = string
  default = "tgw-06ba356a5b17c4b84"
}

variable "privatesubnet_cidrs" {
  type = list(string)
}

variable "rt_cidr_blocks" {
  type = list(string)
}

variable "inviz_sg_id" {
  type = string
}

variable "cluster_sg_add_rules_cidr" {
  type = list(string)
}

/*variable "cluster_sg_add_rules_cidr_2" {
  type = list(string)
}

variable "cluster_sg_add_rules" {
  
}*/

variable "coredns_version" {
  
}

variable "kube_proxy_version" {
  
}

variable "vpc_cni_version" {
  
}

variable "ebs_csi_version" {
  
}

variable "disk_size" {
  type = string
  default = "50"
}

variable "key_name" {
  type = string
  default = "qasapkey"
}

variable "min_size_workers_1" {
  type = string
  default = "1" 
}

variable "max_size_workers_1" {
  type = string
  default = "5"  
}

variable "desired_size_workers_1" {
  type = string
  default = "1"
}

variable "cap_type_workers_1" {
  
}

variable "ami_type_workers_1" {
  type = string
  default = "value"
}

variable "node_ami_version_workers_1" {
  
}

variable "instance_types_workers_1" {
  #type = string
}

### EKS ELASTIC WORKER VAR
variable "min_size_elastic_worker" {
  
}

variable "max_size_elastic_worker" {
  
}

variable "desired_size_elastic_worker" {
  
}

variable "instance_types_elastic_worker" {
  
}

variable "cap_type_elastic_worker" {
  
}

### EKS MTELASTIC WORKER VAR
variable "min_size_mtelastic_worker" {
  
}

variable "max_size_mtelastic_worker" {
  
}

variable "desired_size_mtelastic_worker" {
  
}

variable "instance_types_mtelastic_worker" {
  
}

variable "cap_type_mtelastic_worker" {
  
}

#monitoring Node Group
variable "min_size_monitoring_worker" {
  
}

variable "max_size_monitoring_worker" {
  
}

variable "desired_size_monitoring_worker" {
  
}

variable "instance_types_monitoring_worker" {
  
}

variable "cap_type_monitoring_worker" {
  
}



variable "auth_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::032560443992:role/Inviz-EksCodeBuildKubectlRole"
      username = "build"
      groups   = ["system:masters"]
    },
  ]
}

variable "auth_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::822771609266:user/sredlapalli_t@tataunistore.com"
      username = "sredlapalli_t@tataunistore.com"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::822771609266:user/ssindigeri_t@tataunistore.com"
      username = "ssindigeri_t@tataunistore.com"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::822771609266:user/nsingh2_t@tataunistore.com"
      username = "nsingh2_t@tataunistore.com"
      groups   = ["system:masters"]
    },
  ]
}

variable "auth_accounts" {
    type = list
    default = ["032560443992","089867193557","745918317257","080542245903"]  
}

/*variable "centraleks_cluster_autoscaler_sa" {
  
}*/

variable "centraleks_cluster_autoscaler_image_tag" {
  
}

variable "centraleks_alb_controller_image_tag" {
  
}

variable "centraleks_metrics_server_image_tag" {
  
}

variable "centraleks_efs_csi_image_tag" {
  
}

variable "approver_name" {
  
}

variable "efs_widget_req" {
  
}

variable "efs_datascience_req" {

}
variable "efs_token" {
  
}

variable "efs_token_2" {

}
variable "efs_token_3" {

}

#Velero
variable "velero_req" {
  default = "false"
}

variable "vel_s3_bkt_arns" {
  type = list(string)
}

#api_gw_variables
variable "api_gw_req" {
  default = "false"
}
variable "api_gw_nlb_name" {
  
}
variable "api_gw_nlb_tg_name" {
  
}
variable "tg_name_tls" {
  
}
variable "api_gw_tg_healthcheck_path" {
  
}
variable "tg_alb_arn" {
  
}
variable "cert_arn" {
  
}
variable "api_gw_name" {
  
}
variable "api_gw_resource_path" {
  
}
variable "api_key_name" {
  
}
variable "api_key_value" {
  
}
variable "crm_usage_plan_name" {
  
}
variable "vpc_link_name" {
  
}
variable "api_path" {
  
}
variable "stage_name" {
  
}
variable "custom_domain_apigw" {
  default = "crmapi.tatausnistore.com"
}
variable "zone_domain" {
  default = "tataunistore.com"
}
variable "acm_cert_arn" {
  default = "arn:aws:acm:ap-south-1:032560443992:certificate/af5a43c7-a40b-4ba2-bb5b-0101456e0ca3"
}
variable "crm_enc_base_path" {
  default = "/crm/v1"
}

##Elasticache Martech

variable "martech_elasticache_subnetgroup_name" {

}

variable "martech_elasticache_id" {

}

variable "martech_elasticache_nodetype" {
  
}
