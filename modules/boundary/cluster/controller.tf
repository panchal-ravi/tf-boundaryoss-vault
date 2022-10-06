data "aws_ami" "an_image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["${var.owner}-boundary-*"]
  }
}

resource "aws_instance" "boundary-controller" {
  ami                    = data.aws_ami.an_image.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_key_name
  subnet_id              = var.private_subnets[0]
  vpc_security_group_ids = [module.controller-inbound-sg.security_group_id]
  
  tags = {
    Name  = "${var.deployment_id}-controller"
    owner = var.owner
  }

  provisioner "file" {
    content     = filebase64("${path.root}/files/boundary/install.sh")
    destination = "/tmp/install_base64.sh"
  }

  provisioner "file" {
    content = templatefile("${path.root}/files/boundary/boundary-controller.tpl", {
      rds_hostname         = var.rds_hostname,
      boundary_db_username = var.boundary_db_username,
      boundary_db_password = var.boundary_db_password,
      private_ip           = self.private_ip
    })
    destination = "/tmp/boundary-controller.hcl"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo base64 -d /tmp/install_base64.sh > /tmp/install.sh",
      "sudo mv /tmp/install.sh /home/ubuntu/install.sh",
      "sudo chmod +x /home/ubuntu/install.sh",
      "sudo mv /tmp/boundary-controller.hcl /etc/boundary-controller.hcl",
      "sudo /home/ubuntu/install.sh controller",
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
