
resource "aws_instance" "wordpressinstance" {
  # count         = length(var.subnets)
  ami           = var.instance-ami
  instance_type = "t2.micro"
  # subnet_id     = var.subnets[count.index]
  subnet_id     = var.subnet_id

  key_name      = var.key-pair

  vpc_security_group_ids = var.security_group_ids

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/tud-aws.pem")
    host        = self.public_ip
  }

  # Copy provisioning script to instance
  provisioner "file" {
    source      = "../php/index.php"
    destination = "/home/ubuntu/index.php"
  }

  provisioner "file" {
    source      = "../scripts/provision.sh"
    destination = "/home/ubuntu/provision.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "touch /tmp/foo.txt",
      "sudo apt update && sudo apt upgrade -y",
      "chmod 777 /home/ubuntu/provision.sh",
      "sudo /home/ubuntu/provision.sh"
    ]
  }
  tags = {
    Name = "wordpress-instance"
  }
}

