terraform {
  required_providers {
    vcfa = {
      source  = "vmware/vcfa"
      version = "~> 1.0.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "vcfa" {
  user                 = var.vcfa_username
  password             = var.vcfa_password
  url                  = var.vcfa_url
  org                  = var.vcfa_org
  allow_unverified_ssl = "true"
  logging              = true
}

provider "local" {
}

data "vcfa_kubeconfig" "kube_config" {
  project_name              = var.vcfa_project
  supervisor_namespace_name = var.supervisor_namespace_name
}

# The kubeconfig can be used to configure the Kubernetes provider
provider "kubernetes" {
  host     = data.vcfa_kubeconfig.kube_config.host
  insecure = data.vcfa_kubeconfig.kube_config.insecure_skip_tls_verify
  token    = data.vcfa_kubeconfig.kube_config.token
}

