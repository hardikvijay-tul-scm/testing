#Deploying AWS load balancer controller for centraleks cluster using Helm charts

resource "helm_release" "loadbalancer_controller" {
  
  depends_on = [module.eks, module.cluster_autoscaler_irsa_role]
  
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  namespace = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.load_balancer_controller_irsa_role.iam_role_arn
  }

  set {
    name = "image.repository"
    value = "602401143452.dkr.ecr.ap-south-1.amazonaws.com/amazon/aws-load-balancer-controller"
  } 

  set {
    name = "image.tag"
    value = var.centraleks_alb_controller_image_tag
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }  

  set {
    name  = "region"
    value = var.aws_region
  }        
    
}
