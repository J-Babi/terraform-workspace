terraform {
  backend "remote" {
#    hostname     = "tfe.rogers.com"
    hostname     = "https://app.terraform.io"
#    organization = "aws"
    organization = "babis-jul"
    workspaces {
        name = "aws-msr-cast-dev"
    }
  }
  required_version = "1.0.1"
}
