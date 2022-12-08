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
  access_key = "ASIAZ3DCZEO2E76NVFX3"
  secret_key = "rkl/sRGdkbs63NApKoqVdufmO1vOycrB4/sQDJgD"
  token      = "FwoGZXIvYXdzEDgaDGFkw3P+ZGc0gqvw5SLJAfNOis1g7Mov67WvGQGN8a7ItsGaefRt05SP07UxhphEM8YS9tIy/TWDX98cl9b1s0/rxtVBZuhWWMIhLnThGjt+5V8rX9diIfxz9xSojrE0vMyi7C8QTNJaz+UYM21Jh7NbgbV6+kmToyph8fo0mCOfYHLmELUScCvBuAnc9s7iUnMGIRX/AhCMaa0/hMSrDXesyleM/3zrrBXAOyjwt63QT4zovyMVCGZTkKgmNfknLHl9+SblWWmn2/ZyzIztjIEZLT8BZXMm1yiNxMmcBjItGBm47rXXdz87VRez5o5EPnL9n/8HTYfEuYXlBh+iSOf9u+KGZR2DDBBH7/Bb"
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
  user_data              = file("standalone_userdata.sh")
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
  tags = {
    Name = "Management Node"
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
    command = "'${nonsensitive(tls_private_key.pk.private_key_pem)}' | Out-File -FilePath .\\keypair.pem"
    interpreter = ["PowerShell", "-Command"]
  }
}
