resource "random_id" "creation_token" {
  byte_length   = 8
  prefix        = "${var.environment}-"
}

resource "aws_efs_file_system" "swarm_fs" {
  creation_token = "${random_id.creation_token.hex}"

  tags {
    Name = "swarm-${var.environment}-efs"
    CreationToken = "${random_id.creation_token.hex}"
  }

}

resource "aws_efs_mount_target" "swarm_efs_target" {
  file_system_id = "${aws_efs_file_system.swarm_fs.id}"
  subnet_id = "${var.subnet_id}"
  security_groups = ["${aws_security_group.swarm_sg.id}"]
}