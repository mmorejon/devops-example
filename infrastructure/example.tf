# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}

variable "domain_ip" {
  default = "178.128.139.51"
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "do" {
  name       = "do ssh"
  public_key = "${file("~/.ssh/ssh_do.pub")}"
}

resource "digitalocean_domain" "mmorejon" {
  name       = "mmorejon.io"
  ip_address = "${var.domain_ip}"
}

resource "digitalocean_record" "jenkins" {
  domain = "${digitalocean_domain.mmorejon.name}"
  type   = "CNAME"
  name   = "jenkins"
  value  = "@"
}

resource "digitalocean_record" "example" {
  domain = "${digitalocean_domain.mmorejon.name}"
  type   = "CNAME"
  name   = "example"
  value  = "@"
}

resource "digitalocean_kubernetes_cluster" "example" {
  name    = "example"
  region  = "ams3"
  version = "1.14.1-do.3"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

locals {
  basename = "do-${digitalocean_kubernetes_cluster.example.region}-${digitalocean_kubernetes_cluster.example.name}"

  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${digitalocean_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate}
    server: ${digitalocean_kubernetes_cluster.example.endpoint}
  name: ${local.basename}
contexts:
- context:
    cluster: ${local.basename}
    user: ${local.basename}-admin
  name: ${local.basename}
current-context: ${local.basename}
kind: Config
preferences: {}
users:
- name: ${local.basename}-admin
  user:
    client-certificate-data: ${digitalocean_kubernetes_cluster.example.kube_config.0.client_certificate}
    client-key-data: ${digitalocean_kubernetes_cluster.example.kube_config.0.client_key}


KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}
