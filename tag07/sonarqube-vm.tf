terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Suche das neueste Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group für SonarQube VM
resource "aws_security_group" "sonarqube" {
  name        = "sonarqube-sg"
  description = "Security group for SonarQube VM"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SonarQube
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.ubuntu.id  # Neuestes Ubuntu 24.04 LTS
  instance_type          = "t3.large"              # Min 8GB RAM
  vpc_security_group_ids = [aws_security_group.sonarqube.id]
  user_data              = base64encode(file("${path.module}/cloud-init.yml"))

  tags = {
    Name = "sonarqube-server"
  }
}

# Elastic IP
resource "aws_eip" "sonarqube" {
  instance = aws_instance.sonarqube.id
  domain   = "vpc"

  tags = {
    Name = "sonarqube-eip"
  }
}

# Output
output "sonarqube_ip" {
  value       = aws_eip.sonarqube.public_ip
  description = "Elastic IP für SonarQube"
}

output "sonarqube_url" {
  value       = "http://${aws_eip.sonarqube.public_ip}:9000"
  description = "SonarQube URL"
}
