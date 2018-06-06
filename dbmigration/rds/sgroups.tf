resource "aws_security_group" "postgre_sg" {

  name = "postgresql-${var.environment}-sg"
  description = "Ports "

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags {
    Name = "postgre-${var.environment}-sg"
    Application = "postgresql"

  }


}