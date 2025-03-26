terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_access_key
}

// Remote state data source
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "solip-project"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

// Amazon Linux AMI
data "aws_ami" "amazon-linux-ami" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

// Aws Key Pair
resource "aws_key_pair" "shh-key" {
  key_name   = "project-key"
  public_key = var.project_key
}

resource "aws_instance" "public" {
  ami                         = data.aws_ami.amazon-linux-ami.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.shh-key.key_name
  security_groups             = [aws_security_group.sg["public"].id]
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/install_httpd.sh")
  root_block_device {
    encrypted = true
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    var.tags, {
      Name = "${var.prefix}-pulbic"
    }
  )
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon-linux-ami.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.shh-key.key_name
  security_groups             = [aws_security_group.sg["bastion"].id]
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[1]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/install_httpd.sh")
  root_block_device {
    encrypted = true
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    var.tags, {
      Name = "${var.prefix}-bastion"
    }
  )
}

resource "aws_instance" "private" {
  count                       = 2
  ami                         = data.aws_ami.amazon-linux-ami.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.shh-key.key_name
  security_groups             = [aws_security_group.sg["private"].id]
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_ids[count.index]
  associate_public_ip_address = false
  root_block_device {
    encrypted = true
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    var.tags, {
      Name = "${var.prefix}-private-${count.index + 1}"
    }
  )
}
