provider "aws" {
    region = "us-east-1"
}

resource "aws_ecr_repository" "ecr-repo" {
  name                 = "node-app"
  image_tag_mutability = "MUTABLE"
}

resource "aws_instance" "dev-web" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name = "ssh-key-node-server"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = file("install.sh")
  tags = {
    Name = "Dev Server"
  }
}

resource "aws_instance" "qa-web" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name = "ssh-key-node-server"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = file("install.sh")
  tags = {
    Name = "QA Server"
  }
}

resource "aws_instance" "prod-web" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name = "ssh-key-node-server"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = file("install.sh")
  tags = {
    Name = "Prod Server"
  }
}

resource "aws_key_pair" "ssh-key-node-server" {
  key_name   = "ssh-key-node-server"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgURul3msQH3MxgRQJA99Ath2/NAPFs60SWyzcec1asELbCHEhkXGYJBzjJKtj/RHAIU2cWM5b1goaH1Ip5SJAfM3X/K7NZ31XMA5rW8d6oByUYW2y56pUR+Tdd/ZNbdzOSNHpShLCmAvc0hMpx95jCR11INmXuXEaOhdFitLaRx6tGYNiBSn8Ho4UBUQhlQryOhsrgqGw8QX8h7UKA0j9B67ytzFchEAfpSrfvC7qVKAPNAXQiubuTYMlQrgSo1/wEPfEQaJ9SYzdH/hkYwc1YJALXDS6tpHeP3HPdrA0lvhd79bQygj3FNuohm+VuMcwPeaKU5iy7jmSF1BWtUAFsA3bCUXL1hrxj04Vgn9tkDmjBHm9g8uSANbHHG5pXVqn/isGYbTB+Of+P1hBPbMe/5A1u5bmwxYVywOMD84R7rNFckUhbTZbIVst5nUtxST0CU2pH1oGuaLQj7MVArXdmg+cUis6fw++wKjqecXUXCfYSoAnglQSMgHXhHDFMlU= gaurav@srv"
}



resource "aws_security_group" "allow_tls" {
  name        = "web server sg"
  description = "Allow Port 22 and 80"
  vpc_id      = var.vpc_id

  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "80 to Public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Web_Server_SG"
  }
}

resource "aws_iam_role" "iam_ecr_role" {
  name = "ecr_role_for_ec2"
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
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess"]
}

resource "aws_iam_instance_profile" "ec2_profile" {                             
    name  = "ec2_profile"                         
    role = aws_iam_role.iam_ecr_role.name
}