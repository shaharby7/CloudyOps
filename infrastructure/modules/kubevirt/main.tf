resource "kubernetes_namespace" "vmis" {
  metadata {
    name = "vmis"
  }
}


resource "helm_release" "kubevirt" {
  count   = 1
  name    = "kubevirt"
  chart   = "${var.charts_path}/kubevirt"
  wait    = true
  version = "0.1.5"
}

# Waits for kubevirt operator to be aviable
resource "null_resource" "wait_for_kubevirt" {
  depends_on = [helm_release.kubevirt]

  provisioner "local-exec" {
    command = <<-EOC
 kubectl -n kubevirt wait kubevirt kubevirt --for condition=Available --timeout=900s
 EOC
  }
}


resource "helm_release" "cloud_init_user_data" {
  depends_on = [null_resource.wait_for_kubevirt]
  count      = 1
  name       = "cloud-init-user-data"
  chart      = "${var.charts_path}/cloud-init-user-data"
  wait       = true
  version    = "0.1.15"
}
