resource "aws_instance" "swarm_master_node" {

  ami = "${var.ami_id}"
  instance_type = "${var.instance_size}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  source_dest_check = false
  key_name = "${var.aws_ssh_key}"
  security_groups = ["${aws_security_group.swarm_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.swarm_instance_profile.name}"

  root_block_device {
    delete_on_termination = "true"
    volume_size = "50"
    volume_type = "gp2"
  }

  tags {
    environment  = "${var.environment}"
    role = "swarm"
    Name = "swarm_master_node-${var.environment}"
  }

 depends_on = ["aws_security_group.swarm_sg"]

  connection {
    type = "ssh"
    user = "admin"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo /usr/bin/docker swarm init --advertise-addr ${aws_instance.swarm_master_node.private_ip}",
      "sudo mkdir /swarm-efs",
      "sudo mount -t nfs4 -o nfsvers=4.1 ${aws_efs_mount_target.swarm_efs_target.dns_name}:/ /swarm-efs",
      "sudo su -c \"echo '${aws_efs_mount_target.swarm_efs_target.dns_name}:/ /swarm-efs nfs defaults,vers=4.1 0 0' >> /etc/fstab\"",
      "sudo su -c \"/usr/bin/docker swarm join-token worker -q > /swarm-efs/join-token\""
    ]
  }
}

resource "aws_instance" "swarm_node" {
  count = "${var.number_of_nodes}"

  ami = "${var.ami_id}"
  instance_type = "${var.instance_size}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  source_dest_check = false
  key_name = "${var.aws_ssh_key}"
  security_groups = ["${aws_security_group.swarm_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.swarm_instance_profile.name}"

  root_block_device {
    delete_on_termination = "true"
    volume_size = "50"
    volume_type = "gp2"
  }

  tags {
    environment  = "${var.environment}"
    role = "swarm"
    Name = "swarm_${count.index}_node-${var.environment}"
  }

 depends_on = ["aws_security_group.swarm_sg"]

  connection {
    type = "ssh"
    user = "admin"
  }


  provisioner "remote-exec" {
        inline = [
      "sudo mkdir /swarm-efs",
      "sudo mount -t nfs4 -o nfsvers=4.1 ${aws_efs_mount_target.swarm_efs_target.dns_name}:/ /swarm-efs",
      "sudo su -c \"echo '${aws_efs_mount_target.swarm_efs_target.dns_name}:/ /swarm-efs nfs defaults,vers=4.1 0 0' >> /etc/fstab\"",
      "sudo /usr/bin/docker swarm join --token $(sudo cat /swarm-efs/join-token) ${aws_instance.swarm_master_node.private_ip}:2377"
    ]
  }

}