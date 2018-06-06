variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "eu-west-1"
}
variable "s3_states_bucket" {}
variable "environment" {}

variable "vpc_id" {}
variable "subnet_id" {}
variable "subnet_cidr" {}

variable "ami_id" {}
variable "instance_size" {}
variable "aws_ssh_key" {}
variable "number_of_nodes" {}