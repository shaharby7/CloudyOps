
variable "host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "charts_path" {
  type    = string
}

variable "argocd_events" {
  type = bool
  default = false
}
