locals {
  instance_name = "$(terraform.workspace)-instance"
  public_subnets  = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1b.id]
  private_subnets = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id]
  private_key_path = "~/.ssh/${var.key-pair}.pem"
  servers         = ["s1", "s2"]
}

resource "aws_instance" "wordpressinstance" {
  count         = length(local.public_subnets)
  ami           = var.instance-ami
  instance_type = "t2.micro"
  subnet_id     = local.public_subnets[count.index]
  key_name      = var.key-pair
  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-http.id,
  aws_security_group.allow-https.id]

  user_data = <<-EOF
	  #!/bin/bash
	  sudo touch /tmp/foo.txt
	  sudo apt update
	  # sudo apt upgrade -y
          sudo apt install apache2 -y
	  EOF

  tags = {
    Name = "wordpress-instance"
  }
}

output "private_key_path_output" {
   value = local.private_key_path
}

