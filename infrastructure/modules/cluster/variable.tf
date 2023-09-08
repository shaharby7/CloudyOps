variable "platform" {
  type        = string
  default     = "local"
  description = "Platform to run on - local/aws/gcp"
}

variable "cluster_name" {
  type        = string
  description = "Cluster identifier"
}

variable "kubernetes_version" {
  type        = string
  default     = "v1.28.1"
  description = "k8s version to be deployed"
}
