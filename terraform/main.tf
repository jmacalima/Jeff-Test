
provider "aws" {
    region = "${var.aws_region}"
}

module "serverless-application" {
  source = "./services/"
}


