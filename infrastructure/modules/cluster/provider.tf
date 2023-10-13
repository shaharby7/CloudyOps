provider "minikube" {
  kubernetes_version = var.kubernetes_version
}

provider "kubernetes" {
  host                   = module.minikube.0.host
  client_certificate     = module.minikube.0.client_certificate
  client_key             = module.minikube.0.client_key
  cluster_ca_certificate = module.minikube.0.cluster_ca_certificate
}