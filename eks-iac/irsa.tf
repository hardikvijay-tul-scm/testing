module "cluster_autoscaler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.9.2"
  role_name                        = "cluster-autoscaler-centraleks"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_name]
  oidc_providers = {
    centraleks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:autoscaler-aws-cluster-autoscaler"]
    }
  }
  tags = {
    Owner = "centraleks"
  }
}

module "efs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.9.2"
  role_name             = "efs-csi-centraleks"
  attach_efs_csi_policy = true
  oidc_providers = {
    centraleks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
  tags = {
    Owner = "centraleks"
  }
}

module "load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.9.2"
  role_name                              = "load-balancer-controller-centraleks"
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    centraleks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
  tags = {
    Owner = "centraleks"
  }
}

module "ebs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.9.2"
  role_name             = "ebs-csi-centraleks"
  attach_ebs_csi_policy = true
  oidc_providers = {
    centraleks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
  tags = {
    Owner = "centraleks"
  }
}
