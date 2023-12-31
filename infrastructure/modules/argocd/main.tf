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
  timeout    = 1500
  values = [
    templatefile("${path.module}/templates/argocd-values.yaml", {})
  ]
}

resource "kubernetes_namespace" "runspace" {
  metadata {
    name = "runspace"
  }
}

resource "kubernetes_namespace" "argo-events" {
  depends_on = [helm_release.argo-cd]
  metadata {
    name = "argo-events"
  }
}

resource "helm_release" "argo-events" {
  depends_on = [kubernetes_namespace.argo-events]
  count      = var.argo_events ? 1 : 0
  name       = "argo-events"
  namespace  = kubernetes_namespace.argo-events.metadata.0.name
  chart      = "argo-events"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "2.4.1"
  wait       = true
  timeout    = 1500
}

resource "kubernetes_namespace" "argo-workflows" {
  depends_on = [helm_release.argo-cd]
  metadata {
    name = "argo-workflows"
  }
}

resource "helm_release" "argo-workflows" {
  depends_on = [kubernetes_namespace.argo-workflows]
  count      = var.argo_workflows ? 1 : 0
  name       = "argo-workflows"
  namespace  = kubernetes_namespace.argo-workflows.metadata.0.name
  chart      = "argo-workflows"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "0.37.1"
  wait       = true
  timeout    = 1500
  values = [
    templatefile("${path.module}/templates/argo-workflows-values.yaml", {})
  ]
}

resource "helm_release" "application_manager" {
  depends_on = [helm_release.argo-cd, helm_release.argo-events, helm_release.argo-workflows]
  count      = 1
  name       = "application-manager"
  namespace  = kubernetes_namespace.argocd.metadata.0.name
  chart      = "${var.charts_path}/application-manager"
  wait       = true
  version    = "0.1.10"
  values = [
    templatefile("${path.module}/templates/applications-manager-values.yaml", {
      environment : var.environment
    })
  ]
}
