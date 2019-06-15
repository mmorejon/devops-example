terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "devops-example"

    workspaces {
      name = "example"
    }
  }
}
