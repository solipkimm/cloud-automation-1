variable "access_key" {
  type        = string
  description = "AWS access key"
}

variable "secret_access_key" {
  type        = string
  description = "AWS secret access key"
}

variable "tags" {
  default = {
    "Owner"   = "Solip",
    "Project" = "Automation"
  }
  type        = map(any)
  description = "Default tags for all AWS resources"
}

variable "prefix" {
  default     = "TF"
  type        = string
  description = "Name prefix"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  description = "Availability zones"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}
