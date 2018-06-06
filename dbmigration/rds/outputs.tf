output "rds_endpoint" {
  value = "${split(":", aws_db_instance.postgre.endpoint )}"
}
output "rds_arn" {
  value = "${aws_db_instance.postgre.arn}"
}

output "rds_user" {
  value = "${aws_db_instance.postgre.username}"
}

output "rds_password" {
  value = "${aws_db_instance.postgre.password}"
}

output "rds_database" {
  value = "${aws_db_instance.postgre.name}"
}
