terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.48.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.7.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.15.0"
    }
  }
  backend "s3" {
  }
}

provider "aws" {
  #profile = var.aws_profile
  region  = var.aws_region
  /*default_tags {
   tags = {
     Environment = "${var.env}-centraleks"
   }
 }*/
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cecluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cecluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cecluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cecluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cecluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cecluster.token
  }
}
