module "minikube" {
  count  = var.platform == "local" ? 1 : 0
  source = "./modules/minikube"
  cluster_name = var.cluster_name
}
