data "aws_caller_identity" "current" {}

resource "aws_iam_instance_profile" "swarm_instance_profile" {
  name  = "swarm_${var.environment}_instance_profile"
  role = "${aws_iam_role.swarm_instance.name}"
  depends_on = ["aws_iam_role.swarm_instance"]
}

resource "aws_iam_role" "swarm_instance" {
  name = "swarm_${var.environment}_instances"
  path = "/"
  description = "Role discrbes SWARM nodes access"
  assume_role_policy = "${file("${path.module}/policies/ec2-assume-role.json")}"
}

resource "aws_iam_policy" swarm_instances{
  name = "swarm_${var.environment}_instances"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "elasticfilesystem:*",
      "Effect": "Allow",
      "Resource": "arn:aws:elasticfilesystem:${var.aws_region}:${data.aws_caller_identity.current.account_id}:file-system/${aws_efs_file_system.swarm_fs.id}"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "swarm_instance_attach" {
  name = "swarm_${var.environment}_instance_role_attach"
  roles = ["${aws_iam_role.swarm_instance.name}"]
  policy_arn = "${aws_iam_policy.swarm_instances.arn}"
  depends_on = ["aws_iam_role.swarm_instance"]
}