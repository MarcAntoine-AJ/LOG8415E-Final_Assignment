terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAZ3DCZEO2H63JWZPI"
  secret_key = "8RGpgNRMFHVrHM6apUsJX83eS/W6DeHm6Ak/ccMF"
  token      = "FwoGZXIvYXdzEIz//////////wEaDBTqmSHdNvL15mEyHSLJAcQe5gtRIJWinmW36l42y5BWnt0ZG8DVLcMAF242n7479jkpgSGkNBo33i5gODz0vPOcokpsUd/Bjhume/Zkraklhu75a2StlzsgH5Hnh1Z5i09QtyHx8LpmUwXG9pJ0gPuPGa8DwY/PFAyNNDFMrAuHDLh3i7QY3skwqNuNC3eChvcr8xR1Kh1Z25csJnTwHuTKJa7ohelmFMq4YtaZXoJyLk07ygp24nIQtsLFtWG6GgerHeKAefWZ8X6faWSLEb4uq8/N7jd8KyjCq5SdBjItzv+trkkHxRX7TBTNtxZwaI+8tpffD57HhMK/53LCJ/LEQqJcrqMVEr0WZ7kN"
}


resource "aws_security_group" "security_gp" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "stand-alone-MYSQL" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("standalone_userdata.sh")
  key_name               = aws_key_pair.kp.key_name
}

resource "aws_instance" "cluster-MYSQL-data-node1" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  key_name               = aws_key_pair.kp.key_name
  tags = {
    Name = "Data Node 1"
  }
}

resource "aws_instance" "cluster-MYSQL-data-node2" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  key_name               = aws_key_pair.kp.key_name
  tags = {
    Name = "Data Node 2"
  }
}

resource "aws_instance" "cluster-MYSQL-data-node3" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  key_name               = aws_key_pair.kp.key_name
  availability_zone      = "us-east-1c"
  tags = {
    Name = "Data Node 3"
  }
}

resource "aws_instance" "cluster-MYSQL-management-node" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  key_name               = aws_key_pair.kp.key_name
  tags = {
    Name = "Management Node"
  }
}

resource "aws_instance" "proxy" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  key_name               = aws_key_pair.kp.key_name
  user_data              = file("standalone_userdata.sh")
  tags = {
    Name = "Proxy"
  }
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "myKey" # Create "keypair" to AWS.
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create "keypair.pem" to your computer.
    command = "'${nonsensitive(tls_private_key.pk.private_key_pem)}' | Out-File -FilePath ..\\Proxy\\keypair.pem"
    interpreter = ["PowerShell", "-Command"]
  }
}
