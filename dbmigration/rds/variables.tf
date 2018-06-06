variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "eu-west-1"
}

variable "environment" {}

variable "rds_instance_size" {}
variable "allocated_storage" {}
variable "postgresql_database" {}
variable "postgresql_user" {}
variable "postgresql_pass" {}
variable "vpc_cidr" {}
variable "vpc_id" {}

