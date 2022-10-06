source "amazon-ebs" "ubuntu-image" {
  ami_name = "${var.owner}-boundary-{{timestamp}}"
  region = "${var.aws_region}"
  instance_type = var.aws_instance_type
  tags = {
    Name = "${var.owner}-boundary"
  }
  source_ami_filter {
      filters = {
        virtualization-type = "hvm"
        name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
        // name = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
        root-device-type = "ebs"
      }
      owners = ["099720109477"]
      most_recent = true
  }
  communicator = "ssh"
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.ubuntu-image"
  ]
  /* provisioner "file" {
    source      = "../../files/consul.service"
    destination = "/tmp/consul.service"
  } */
  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt install unzip -y",
      "sudo apt install default-jre -y",
      "sudo apt install net-tools -y",
      "sudo apt install postgresql-client -y",
      "sudo apt install jq -y",
      "curl -k -O \"https://releases.hashicorp.com/boundary/${var.boundary_version}/boundary_${var.boundary_version}_linux_amd64.zip\"",
      "unzip boundary_${var.boundary_version}_linux_amd64.zip",
      "sudo mv boundary /usr/local/bin"
    ]
  }

}
