terraform {
  backend "s3" {
    bucket = "solip-project"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}
