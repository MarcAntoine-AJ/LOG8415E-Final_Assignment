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
  access_key = "ASIAZ3DCZEO2FZS5D2GU"
  secret_key = "mmf2XGGW/FXS29/9tBi0OU71jStzakAsowj01y8p"
  token      = "FwoGZXIvYXdzEDoaDA/pgPR5R3r5KIVVziLJAcdYhExlVr+/9zK5HRJTPvCtj2vpsXlzqcEPjr9oukjftyAbDZ+/rifpBtlOGdiEc16KxGr4sz1/H0ZCwREvV50Ibuz8lwCZPJple+itrKZCvsBD+G1VT+qY9Jl3SkkcYpjEVrVLK78yMjluFqyMxhb39YMGrF0E30PZZTOHMMmVWBpxn6b5YQU/Lv1p6Jk/bHpZcCJpeBcs18XfiOahsTaQMvPPKOggM9qnAAA48Tkuvm6JL+g2Y8fBAZhNsLklN6ABHKYq9Wzy+yiBjsqcBjItDYgHskTMwh/SXW4SLG7aYb1ycgdxyS6kY5FX0HBD/qLq+YyME3rqT2KUJCYH"
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
  instance_type          = "t2.micro"
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
  key_name   = "myKey" # Create "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "'${nonsensitive(tls_private_key.pk.private_key_pem)}' | Out-File -FilePath ..\\Proxy\\keypair.pem"
    interpreter = ["PowerShell", "-Command"]
  }
}
