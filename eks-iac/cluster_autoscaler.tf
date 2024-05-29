#Deploying cluster auto scaler for centraleks cluster using Helm charts

resource "helm_release" "autoscaler" {
  
  depends_on = [module.eks, module.cluster_autoscaler_irsa_role]
    
  name       = "autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  namespace = "kube-system"

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cluster_autoscaler_irsa_role.iam_role_arn
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "autoscaler-aws-cluster-autoscaler"
  }

  set {
    name = "image.repository"
    value = "registry.k8s.io/autoscaling/cluster-autoscaler"
  }

  set {
    name = "image.tag"
    value = var.centraleks_cluster_autoscaler_image_tag
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name = "extraArgs.skip-nodes-with-local-storage"
    value = "false"
  }

  set {
    name = "extraArgs.skip-nodes-with-system-pods"
    value = "false"
  }

  set {
    name = "extraArgs.balance-similar-node-groups"
    value = "true"
  }

}
