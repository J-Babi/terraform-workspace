terraform {
  backend "remote" {
    hostname     = "tfe.rogers.com"
    organization = "aws"
    workspaces {
        name = "rsm-broadcast-dev"
    }
  }
  required_version = "1.0.1"
}
