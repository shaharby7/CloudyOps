output "argocd-namespace" {
  value = kubernetes_namespace.argocd.metadata.0.name
}
