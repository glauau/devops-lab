provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "k8s-key" {
  key_name = "k8s-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqNXI85jvjIQP4rn+oUvbUvIqvDHLVoLIxX/cMai5HiPn5/eus2meWD5AoIcXMAQRQ0EEqwKQPegqeB3UuhmPtpuu9L5DZodWUL+Kujl3jtjUebryiAG8SqPdm3Xq0FN4OdIb8clJRm7mZXyDnzEG+hH8Lxh/8MDXZ4qNo0kHpXykdyCVt6x5ZXq6PNxebkrloBLi98EWyD591cn4XlWQRT0V9C2t72DAhgbCT2IRmKRGI3XguoR24y+9X4pyXoPlSQBHFj91f3XXH30Su424o8BWqEmI7qYLp/RMJr8YnNSU5siRwp5vgdYa+dI+vijahQXNw35LvkO16suJiqkga2O5c+BibVHQdYaNhq0oD+gqJgGFB0Unk5yee+a9IWGRNmfcfNUkMM1kUjH91ezgOMUeH8pofx94SaCeHsTLm0G+AkKyC+U2gImTE1+F6laV6tjTaEZh6XN6/IJL4YFGUZclni1kVDSsV9bWl7FE4NK4g6jn2dSejiRc4xqLCot8= glaucia@n0280"
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