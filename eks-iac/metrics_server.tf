#Deploying metrics server in centraleks cluster

resource "helm_release" "metrics_server_release" {

  depends_on = [module.eks]
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"

  namespace = "kube-system"   

  set {
    name = "image.repository"
    value = "registry.k8s.io/metrics-server/metrics-server"
  }

  set {
    name = "image.tag"
    value = var.centraleks_metrics_server_image_tag
  }

}
