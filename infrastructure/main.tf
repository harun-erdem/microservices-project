terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.27.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "my-jenkins-server-sec-grp" {
  name        = "my-jenkins-server-sec-grp"
  description = "Allow 22 80 8080"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "microservices-project"
  }
}

resource "aws_instance" "jenkins-server" {
  ami           = "ami-0889a44b331db0194"
  instance_type = "t3a.medium"
  key_name = "harun-key-pair"
  vpc_security_group_ids = [ aws_security_group.my-jenkins-server-sec-grp.id ]
  root_block_device {
    volume_size = 16  
  }

  tags = {
    Name = "microservices-project"
  }

  user_data = file("userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.jenkins-server-profile.name
}

resource "aws_iam_role" "jenkins-server-role" {
  name = "jenkins-server-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [ "arn:aws:iam::aws:policy/AdministratorAccess" ]

  tags = {
    tag-key = "microservices-project"
  }
}

resource "aws_iam_instance_profile" "jenkins-server-profile" {
  name = "jenkins-server-profile"
  role = aws_iam_role.jenkins-server-role.name
}

output "jenkins-server-ip" {
  value = aws_instance.jenkins-server.public_ip
}

output "jenkins-server-URL" {
  value = "http://${aws_instance.jenkins-server.public_ip}:8080"
}