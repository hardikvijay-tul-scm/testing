resource "helm_release" "velero_chart" {
  count = var.velero_req == "yes" ? 1 : 0
  depends_on = [module.eks, module.velero_irsa_role] 
  name       = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  
  namespace = "velero"
  create_namespace = true

  set {
    name  = "configuration.backupStorageLocation.bucket"
    value = "centraleksvelero"
  }

  set {
    name  = "configuration.volumeSnapshotLocation.name"
    value = "qapvvol"
  }


  set {
    name  = "configuration.provider"
    value = "aws"
  }

  set {
    name  = "config.region"
    value = var.aws_region
  }

  set {
    name  = "credentials.useSecret"
    value = "false"
  }
 
  set {
    name  = "initContainers"
    value = yamlencode([
      {
        name = "velero-plugin-for-aws"
        image = "velero/velero-plugin-for-aws:v1.6.1"
        imagePullPolicy = "IfNotPresent"
        volumeMounts = [
          {
            mountPath = "/target"
            name = "plugins"
          }
        ]
      }
    ])
  } 

} 

module "velero_irsa_role" {
  count = var.velero_req == "yes" ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.9.2"
  role_name             = "cluster-velero-centraleks"
  attach_velero_policy  = true
  velero_s3_bucket_arns = var.vel_s3_bkt_arns
  oidc_providers = {
    centraleks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["velero:velero"]
    }
  }
  tags = {
    Owner = "centraleks"
  }
}
