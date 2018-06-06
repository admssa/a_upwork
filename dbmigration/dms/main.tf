provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

data "terraform_remote_state" "rds" {
  backend = "s3"
  config {
    bucket = "devsops-terraform"
    key    = "${var.environment}/dbmigration-rds"
    region = "${var.aws_region}"
  }
}

terraform {
  backend "s3" {
    bucket = "devsops-terraform"
  }
}
