terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "chrisns"

    workspaces {
      name = "mydns"
    }
  }
}

provider "cloudflare" {
  version = "~> 2.0"
  email   = "chris@cns.me.uk"
}


module "cns_me_uk" {
  source     = "./modules/domain"
  domain  = "cns.me.uk"
  redirect_nowww = true
  s3 = true
}