resource "aws_dms_replication_instance" "mongo_postgre_instance" {
  allocated_storage            = "${var.allocated_storage}"
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  engine_version               = "2.4.2"
  multi_az                     = false
  publicly_accessible          = true
  replication_instance_class   = "${var.dms_instance_size}"
  replication_instance_id      = "${var.mongodb_database}-dms-replication-instance-tf"

  tags {
    Name        = "${var.mongodb_database}-dms-${var.environment}-instance"
    environment = "${var.environment}"
  }
}

resource "aws_dms_endpoint" "source" {

  database_name = "${var.mongodb_database}"
  endpoint_id   = "${var.mongodb_database}-dms-${var.environment}-source"
  endpoint_type = "source"
  engine_name   = "mongodb"
  password      = "${var.mongodb_pass}"
  port          = "${var.mongodb_port}"
  server_name   = "${var.mongodb_host}"
  ssl_mode      = "none"
  username      = "${var.mongodb_user}"
  kms_key_arn   = "${aws_dms_replication_instance.mongo_postgre_instance.kms_key_arn}"


  mongodb_settings{
      auth_mechanism = "SCRAM_SHA_1"
      auth_source = "${var.mongodb_database}"
      extract_doc_id = "true"

  }

  tags {
    Name        = "${var.mongodb_host}-dms-${var.environment}-source"
    environment = "${var.environment}"
  }
}

resource "aws_dms_endpoint" "target" {
  database_name = "${data.terraform_remote_state.rds.rds_database}"
  endpoint_id   = "${data.terraform_remote_state.rds.rds_database}-dms-${var.environment}-target"
  endpoint_type = "target"
  engine_name   = "postgres"
  password      = "${data.terraform_remote_state.rds.rds_password}"
  port          = "${data.terraform_remote_state.rds.rds_endpoint[1]}"
  server_name   = "${data.terraform_remote_state.rds.rds_endpoint[0]}"
  ssl_mode      = "none"
  username      = "${data.terraform_remote_state.rds.rds_user}"

  tags {
    Name        = "${data.terraform_remote_state.rds.rds_endpoint[0]}-dms-${var.environment}-target"
    environment = "${var.environment}"
  }
}


resource "aws_dms_replication_task" "mongo_postgres" {
  migration_type = "full-load-and-cdc"
  replication_instance_arn = "${aws_dms_replication_instance.mongo_postgre_instance.replication_instance_arn}"
  replication_task_id = "${var.environment}-${var.mongodb_database}-to-${data.terraform_remote_state.rds.rds_database}"
  source_endpoint_arn = "${aws_dms_endpoint.source.endpoint_arn}"
  cdc_start_time = "1275731457"

  table_mappings = <<EOF
{
    "rules": [
        {
            "rule-type": "selection",
            "rule-id": "1",
            "rule-name": "1",
            "object-locator": {
                "schema-name": "${var.mongodb_database}",
                "table-name": "%"
            },
            "rule-action": "include"
        }
    ]
}
EOF
  target_endpoint_arn = "${aws_dms_endpoint.target.endpoint_arn}"
}
