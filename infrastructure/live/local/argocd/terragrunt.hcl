locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  global_vars      = read_terragrunt_config(find_in_parent_folders("globals.hcl"))
  stage            = local.environment_vars.locals.environment
  charts_path      = local.global_vars.locals.charts_path
}

terraform {
  source = "../../../modules//argocd"
}

include {
  path = find_in_parent_folders()
}


dependency "cluster" {
  config_path                             = "${get_terragrunt_dir()}/../cluster"
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    host                   = "1.1.1.1"
    client_key             = "a"
    client_certificate     = "sha"
    cluster_ca_certificate = "sha"
  }
}

dependency "kubevirt" {
  config_path                             = "${get_terragrunt_dir()}/../kubevirt"
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs                            = {}
}


inputs = {
  stage                  = local.stage
  charts_path            = local.charts_path
  argo_events            = true
  argo_workflows         = true
  host                   = dependency.cluster.outputs.host
  client_key             = dependency.cluster.outputs.client_key
  client_certificate     = dependency.cluster.outputs.client_certificate
  cluster_ca_certificate = dependency.cluster.outputs.cluster_ca_certificate

}
