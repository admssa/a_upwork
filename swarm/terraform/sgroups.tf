resource "aws_security_group" "swarm_sg" {

  name = "swarm-${var.environment}-sg"
  description = "Ports required by our application"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["${var.subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name = "swarm-${var.environment}-sg"
    Application = "swarm"

  }


}