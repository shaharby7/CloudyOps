
output "host" {
  value = module.minikube.0.host
}

output "client_certificate" {
  value = module.minikube.0.client_certificate
  sensitive = true
}

output "client_key" {
  value = module.minikube.0.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value = module.minikube.0.cluster_ca_certificate
  sensitive = true
}
