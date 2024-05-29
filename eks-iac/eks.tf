module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.4.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                   = var.vpc_id
  subnet_ids               = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id, aws_subnet.centraleks_privatesubnet4.id, aws_subnet.centraleks_privatesubnet5.id, aws_subnet.centraleks_privatesubnet6.id]
  control_plane_subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]

  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access  = true
  cluster_enabled_log_types = ["api", "controllerManager", "scheduler", "authenticator", "audit"]

  cluster_addons = {
    coredns = {
      addon_version = var.coredns_version
    }
    kube-proxy = {
      addon_version = var.kube_proxy_version
    }
    vpc-cni = {
      addon_version = var.vpc_cni_version
    }
    aws-ebs-csi-driver = {
      addon_version = var.ebs_csi_version
    }
  }

  cluster_security_group_additional_rules = {
    ingress_source_1 = {
      type = "ingress"
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = var.cluster_sg_add_rules_cidr
    }
    #ingress_source_2 = {
    #  type = "ingress"
    #  from_port = 0
    #  to_port = 0
    #  protocol = -1
    #  cidr_blocks = ["10.22.0.0/16"]
    #}
    egress = {
      type = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
   
  # EKS Managed Node Group(s)  
  eks_managed_node_group_defaults = {
    depends_on = [aws_iam_policy.centraleks_policy]
    force_update_version = true
    ami_type  = "AL2_x86_64"  
    ami_release_version = var.node_ami_version 
    use_custom_launch_template = false
    remote_access = {
      ec2_ssh_key = var.key_name
    }
    disk_size = var.disk_size
    iam_role_additional_policies = {
      additional = aws_iam_policy.centraleks_policy.arn
    }
  }

  eks_managed_node_groups = {
    
    centraleks_workers_1 = {
      subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
      min_size     = var.min_size_workers_1
      max_size     = var.max_size_workers_1
      desired_size = var.desired_size_workers_1
      instance_types = var.instance_types_workers_1
      capacity_type  = var.cap_type_workers_1
      ami_type  = var.ami_type_workers_1              /*  "AL2_x86_64" "AL2_ARM_64"   */
      ami_release_version = var.node_ami_version_workers_1  
      update_config = {
        max_unavailable = 1
      }
      timeouts = {
        create = "600m"
        delete = "600m"
        update = "600m"
      }
      tags = {
        Application = "${var.env}-centraleks"
        NodeGroup = "worker_1"
        Environment = var.cluster_name
        ApprovedBy   = var.approver_name
      }
    }
      
    centraleks_elastic = {
      subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
      min_size     = var.min_size_elastic_worker
      max_size     = var.max_size_elastic_worker
      desired_size = var.desired_size_elastic_worker
      instance_types = var.instance_types_elastic_worker
      capacity_type  = var.cap_type_elastic_worker
      update_config = {
        max_unavailable = 1
      }
      timeouts = {
        create = "600m"
        delete = "600m"
        update = "600m"
      }
      tags = {
        Application = "${var.env}-centraleks"
        NodeGroup = "elastic"
        Environment = var.cluster_name
        ApprovedBy   = var.approver_name
      }
      labels = {
        Application = "elastic"
      }
      taints = {
        dedicated = {
        key    = "dedicated"
        value  = "elastic"
        effect = "NO_SCHEDULE"
        }
      }
    }

    centraleks_mtelastic = {
      subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
      min_size     = var.min_size_mtelastic_worker
      max_size     = var.max_size_mtelastic_worker
      desired_size = var.desired_size_mtelastic_worker
      instance_types = var.instance_types_mtelastic_worker
      capacity_type  = var.cap_type_mtelastic_worker
      update_config = {
        max_unavailable = 1
      }
      timeouts = {
        create = "600m"
        delete = "600m"
        update = "600m"
      }
      tags = {
        Application = "${var.env}-centraleks"
        NodeGroup = "mtelastic"
        Environment = var.cluster_name
        ApprovedBy   = var.approver_name
      }
      labels = {
        Application = "mtelastic"
      }
      taints = {
        dedicated = {
        key    = "dedicated"
        value  = "mtelastic"
        effect = "NO_SCHEDULE"
        }
      }
    }


    centraleks_monitoring = {
      subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
      min_size     = var.min_size_monitoring_worker
      max_size     = var.max_size_monitoring_worker
      desired_size = var.desired_size_monitoring_worker
      instance_types = var.instance_types_monitoring_worker
      capacity_type  = var.cap_type_monitoring_worker
      update_config = {
        max_unavailable = 1
      }
      timeouts = {
        create = "600m"
        delete = "600m"
        update = "600m"
      }
      tags = {
        Application = "${var.env}-centraleks"
        NodeGroup = "monitoring"
        Environment = var.cluster_name
        ApprovedBy   = var.approver_name
      }
      labels = {
        Application = "monitoring"
      }
      taints = {
        dedicated = {
        key    = "dedicated"
        value  = "monitoring"
        effect = "NO_SCHEDULE"
        }
      }
    }
  }
    
  # aws-auth configmap
  manage_aws_auth_configmap = true
  aws_auth_roles = var.auth_roles
  aws_auth_users = var.auth_users
  #aws_auth_accounts = var.auth_accounts

  tags = {
    Environment = "${var.env}-centraleks"
    ApprovedBy   = var.approver_name
  }
}

######## Worker node  module for elastic
#module "eks_managed_node_group_elastic" {
#  count = var.env == "qa" || var.env == "preprod" || var.env == "pt" ? 1 : 0 
#  #depends_on = [module.eks.cluster_arn]
#  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
#  version = "19.4.0"
#  name            = var.elastic_ng_name
#  cluster_name    = var.cluster_name
#  cluster_version = var.cluster_version
#  #vpc_id     = var.vpc_id 
#  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
#  #cluster_security_group_id         = module.eks.node_security_group_id
#  subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
#  min_size     = var.min_size_elastic_worker
#  max_size     = var.max_size_elastic_worker
#  desired_size = var.desired_size_elastic_worker
#  instance_types = var.instance_types_elastic_worker
#  capacity_type  = var.cap_type_elastic_worker
#  ami_type  = "AL2_x86_64"           
#  ami_release_version = var.node_ami_version  
#  update_config = {
#    max_unavailable = 1
#  }
#  use_custom_launch_template = false
#  remote_access = {
#    ec2_ssh_key = var.key_name
#  }
#  disk_size = var.disk_size
#  iam_role_additional_policies = {
#    additional = aws_iam_policy.centraleks_policy.arn
#  }
#  labels = {
#    Application = "elastic"
#  }
#  taints = {
#    dedicated = {
#      key    = "dedicated"
#      value  = "elastic"
#      effect = "NO_SCHEDULE"
#    }
#  }
#  tags = {
#        Application = "${var.env}-centraleks"
#        NodeGroup = "elastic-worker"
#        Environment = var.cluster_name
#        ApprovedBy   = var.approver_name
#      }
#}

## To add security group rules for cluster security group id
resource "aws_security_group_rule" "cluster_security_group" {
  depends_on = [module.eks.cluster_endpoint]
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["10.22.0.0/16"]
  security_group_id = module.eks.cluster_security_group_id
}

data "aws_eks_cluster" "cecluster" {
  #depends_on = [module.eks.cluster_name]
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cecluster" {
  #depends_on = [module.eks.cluster_name]
  name = module.eks.cluster_name
}
