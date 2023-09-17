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

resource "kubernetes_namespace" "runspace" {
  metadata {
    name = "runspace"
  }
}


resource "helm_release" "application_manager" {
  depends_on = [helm_release.argo-cd, kubernetes_namespace.runspace]
  count      = 1
  name       = "application-manager"
  namespace  = kubernetes_namespace.argocd.metadata.0.name
  chart      = "${var.charts_path}/application-manager"
  wait       = false
  version    = "0.1.0"
}
