terraform {
  backend "s3" {
    bucket = "solip-project"
    key    = "webserver/terraform.tfstate"
    region = "us-east-1"
  }
}
