resource "minikube_cluster" "this" {
  vm                 = true
  cluster_name       = var.cluster_name
  nodes              = 1
  kubernetes_version = var.kubernetes_version
}
