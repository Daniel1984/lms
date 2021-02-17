provider "aws" {
  region  = var.region
  profile = var.profile
}

module "remote_state" {
  source      = "../../modules/aws/remote_state"
  prefix      = var.prefix
  environment = var.env
}
