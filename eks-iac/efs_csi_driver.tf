#Deploying efs csi driver for centraleks cluster using Helm charts

resource "helm_release" "efs_csi_driver" {
  
  depends_on = [module.eks, module.cluster_autoscaler_irsa_role]
  
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"

  namespace = "kube-system"     

  set {
    name = "image.repository"
    value = "602401143452.dkr.ecr.ap-south-1.amazonaws.com/eks/aws-efs-csi-driver"
  }     

  set {
    name = "image.tag"
    value = var.centraleks_efs_csi_image_tag
  }  

  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.efs_csi_irsa_role.iam_role_arn
  }
    
}
