resource "aws_db_instance" "postgre" {


  identifier = "${var.postgresql_database}-${var.environment}"
  instance_class = "${var.rds_instance_size}"
  allocated_storage = "${var.allocated_storage}"
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "9.6.6"
  name = "${var.postgresql_database}"
  username = "${var.postgresql_user}"
  password = "${var.postgresql_pass}"
  vpc_security_group_ids = ["${aws_security_group.postgre_sg.id}"]
  publicly_accessible = false

  copy_tags_to_snapshot = true
  multi_az = false

  storage_encrypted = false

  tags {
    environment  = "${var.environment}"
    role = "postgresql"
    Name = "postgresql-${var.environment}"
  }


}

