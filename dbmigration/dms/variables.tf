variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "eu-west-1"
}

variable "environment" {}

variable "mongodb_host" {}
variable "mongodb_port" {}
variable "mongodb_user" {}
variable "mongodb_database" {}
variable "mongodb_pass" {}
variable "dms_instance_size" {}
variable "allocated_storage" {}
