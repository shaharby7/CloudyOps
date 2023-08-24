resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      argo = "true"
    }
  }
}


resource "helm_release" "argo-cd" {
  name       = "argo-cd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.27.0"
  namespace  = kubernetes_namespace.argocd.metadata.0.name
  values = [
    templatefile("${path.module}/templates/argocd-values.yaml", {})
  ]
}

resource "helm_release" "applicatoins-launcher" {
  depends_on = [helm_release.argo-cd]
  count      = 1
  name       = "applications-launcher"
  namespace  = kubernetes_namespace.argocd.metadata.0.name
  chart      = "${var.charts_path}/applications-launcher"
  wait       = false
}