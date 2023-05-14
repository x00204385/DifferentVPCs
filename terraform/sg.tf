resource "aws_security_group" "allow-ssh" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "allow-ssh"
    Purpose = "wordpress-POC"
  }
}


resource "aws_security_group" "allow-http" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-http"
  description = "security group that allows http and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "allow-http"
    Purpose = "wordpress-POC"
  }
}


resource "aws_security_group" "allow-https" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-https"
  description = "security group that allows https and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "allow-https"
    Purpose = "wordpress-POC"
  }
}

resource "aws_security_group" "allow-msql2" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-mysql2"
  description = "security group that allows msql and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "allow-mysql"
    Purpose = "wordpress-POC"
  }
}

resource "aws_security_group" "allow-efs" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-efs"
  description = "EFS security group allow access to port 2049"

  ingress {
    description = "allow inbound NFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "allow-efs"
    Purpose = "wordpress-POC"
  }
}
