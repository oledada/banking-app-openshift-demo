terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33"
    }
    # Si tu utilises l'opérateur OpenShift ou des CRDs spécifiques
    # openshift = {
    #   source  = "smutel/openshift"
    #   version = "~> 0.3"
    # }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"          # ou via variables / variables d'environnement
  config_context = var.kube_context          # contexte kubectl à utiliser
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = var.kube_context
  }
}
