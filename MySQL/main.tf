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
  access_key = "ASIAZ3DCZEO2GOCTYWCV"
  secret_key = "ol8ijDRIZzi97JLNvGOlYVOKEDZxZ9M0TkwXf/rh"
  token      = "FwoGZXIvYXdzENr//////////wEaDFsheu7tOmduZtH+wiLJAat0PS2wTXhbPJVJimMoNdLDyyGJTzZpjS7JuRZs3LeqrIv91+hEgsuaH5Uf9eIgNSaDnBbwgyKTy/Ed6B6EF+SZIpPD63YS/PAmGO7iWCtCeOuo52nTzRBZqn+FE6gJo2rusyQloK5RjrBlSGPaa8CbCWtCYmZKn1PNuWnwl+O9kbU8gHwdOgIkbqg2GppmDq7jTeudHw1/Y3NmIguaxbYEJHaglDge65fwRTjK2jIkyM8TyB8tTmE1qhI6QZdR+7SR8KIESIrvuSjRhrWcBjItxHJZpoDHxiEtqQ38p0wQVUDnQv4rIT8zhoKXdurwYmmRBy+WR1jGWMtKsA34"
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