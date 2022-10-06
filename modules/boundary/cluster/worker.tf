resource "aws_instance" "boundary-worker" {
  ami                    = data.aws_ami.an_image.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_key_name
  subnet_id              = var.public_subnets[0]
  vpc_security_group_ids = [module.worker-inbound-sg.security_group_id]

  tags = {
    Name  = "${var.deployment_id}-worker"
    owner = var.owner
  }

  provisioner "file" {
    content     = filebase64("${path.root}/files/boundary/install.sh")
    destination = "/tmp/install_base64.sh"
  }

  provisioner "file" {
    content = templatefile("${path.root}/files/boundary/boundary-worker.tpl", {
      controller_ip = aws_instance.boundary-controller.private_ip,
      private_ip    = self.private_ip,
      public_ip     = self.public_ip
    })
    destination = "/tmp/boundary-worker.hcl"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo base64 -d /tmp/install_base64.sh > /tmp/install.sh",
      "sudo mv /tmp/install.sh /home/ubuntu/install.sh",
      "sudo chmod +x /home/ubuntu/install.sh",
      "sudo mv /tmp/boundary-worker.hcl /etc/boundary-worker.hcl",
      "sudo /home/ubuntu/install.sh worker",
      "sleep 30",
    ]
  }
  connection {
    type                = "ssh"
    user                = "ubuntu"
    host                = self.private_ip
    private_key         = file("${path.root}/private-key/rp-key.pem")
    bastion_private_key = file("${path.root}/private-key/rp-key.pem")
    bastion_host        = var.bastion_ip
  }
}
