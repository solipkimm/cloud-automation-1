variable "access_key" {
  type        = string
  description = "AWS access key"
  sensitive   = true
}

variable "secret_access_key" {
  type        = string
  description = "AWS secret access key"
  sensitive   = true
}

variable "project_key" {
  type        = string
  description = "Project key"
  sensitive   = true
}

variable "state_file_path" {
  type        = string
  default     = "network/terraform.tfstate"
  description = "Path to the state file"
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

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}
