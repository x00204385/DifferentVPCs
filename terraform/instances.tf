#	echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by '${var.db_password}';" | mysql -u root 
#	echo "CREATE USER '${var.db_username}'@'%' IDENTIFIED WITH mysql_native_password BY '${var.db_password};" | mysql -u root --password=${var.db_password}
#	echo "CREATE USER 'wp_user'@localhost IDENTIFIED BY '${var.db_password}';" | mysql -u root --password=${var.db_password}
#	echo "CREATE DATABASE wp;" | mysql -u root --password=${var.db_password}
#	echo "GRANT ALL PRIVILEGES ON wp.* TO '${var.db_username}'@localhost WITH GRANT OPTION; FLUSH PRIVILEGES;"| mysql -u root --password=${var.db_password}
#      "/home/ubuntu/provision-wordpress.sh"



locals {
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

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/tud-aws-use.pem")
    #private_key = file("~/.ssh/tud-aws.pem")
    host        = self.public_ip
  }

  # Install NFS support and mount the EFS volume. Then execute the provisionining script.
  # Replace the DB endpoint in wp-config.php with the RDS end point
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y"
    ]
  }

  tags = {
    Name = "wordpress-instance"
  }
}



