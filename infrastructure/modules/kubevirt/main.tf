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
 kubectl -n kubevirt wait kubevirt kubevirt --for condition=Available --timeout=300s
 EOC
  }
}


resource "helm_release" "datavolumes" {
  depends_on = [null_resource.wait_for_kubevirt]
  count      = 1
  name       = "datavolumes"
  chart      = "${var.charts_path}/datavolumes"
  wait       = true
  version    = "0.1.3"
}
