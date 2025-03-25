terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_access_key
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(
    var.tags, {
      Name = "${var.prefix}-vpc"
    }
  )
}

// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags, {
      Name = "${var.prefix}-igw"
    }
  )
}

// Public Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" // default route - all traffic
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags, {
      Name = "${var.prefix}-public-rt"
    }
  )
}

// Priavte Route Table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags, {
      Name = "${var.prefix}-private-rt"
    }
  )
}

// Public Subnets
resource "aws_subnet" "public-subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags, {
      Name = "${var.prefix}-public-subnet-${count.index + 1}"
    }
  )
}

// Private Subnets
resource "aws_subnet" "private-subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags, {
      Name = "${var.prefix}-private-subnet-${count.index + 1}"
    }
  )
}

// Public Route Table Association
resource "aws_route_table_association" "public-rta" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

// Priavet Route Table Association
resource "aws_route_table_association" "private-rta" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-rt.id
}
