terraform {
  backend "s3" {
    encrypt = true
    bucket  = "fds-terraform-state"
    key     = "terraform.tfstate"
    region  = "us-east-1"
  }
}
