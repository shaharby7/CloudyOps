resource "helm_release" "argo" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  values = [
    file("${path.module}/argo-cd-values.yaml")
  ]
}
