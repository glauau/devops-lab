provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "k8s-key" {
  key_name = "k8s-key"
  public_key = "ssh-rsa AAAA"
}

resource "aws_security_group" "k8s-sg" {
  name = "k8s-sg"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = true
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    to_port          = 0
    protocol         = "-1"

  }

  ingress {
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k8s-worker" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  key_name = "k8s-key"
  count = 2
  tags = {
    name = "k8s"
    type = "worker"
  }
  security_groups = [aws_security_group.k8s-sg.name]
}

resource "aws_instance" "k8s-master" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  key_name = "k8s-key"
  count = 1
  tags = {
    name = "k8s"
    type = "master"
  }
  security_groups = [aws_security_group.k8s-sg.name]
}
