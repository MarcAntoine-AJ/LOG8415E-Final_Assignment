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
  access_key = "ASIAZ3DCZEO2MICS3T2S"
  secret_key = "GzEVjiuJLEbuvXHdZi/k2jiUC9UHG9p2bjT+nFmd"
  token      = "FwoGZXIvYXdzEIT//////////wEaDBao7ZDjKvSCRbuJgCLJATDUCcqEnB1q+A/glzH5Uq5sx25XJQrtkjGmlYwmiyRiwAIFtia6xTBbhjTs77PXvfw56ALVHrzyn0Ha0iVDmRnP8fSI79aqFrPbMBZje/e/4O6KW4tGjjIoobJG9WyBtCsRmUNrnGs9yXPdKzQIeZUxPdeyRCXuI6tVZcQKRR76C126/XTkBuzuvMGmouasGDOdtMq38aqjMQDxvmDK4nx4RWo1wxgBneD2brbLUS4yVElPU9c+26TgwRwc4UGBUjqSQVbhwx4KJijd3+mbBjItTPZ3/2Pm14+3sY6vkW6XgppNQpWRKKjxwvtAXyHUfvQICOUmur0ABPSGivry"
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
}

resource "aws_instance" "cluster-MYSQL-data-node1" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  tags = {
    Name = "Data Node 1"
  }
}

resource "aws_instance" "cluster-MYSQL-data-node2" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  tags = {
    Name = "Data Node 2"
  }
}

resource "aws_instance" "cluster-MYSQL-data-node3" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
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
  tags = {
    Name = "Management Node"
  }
}