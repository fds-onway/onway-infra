terraform {
  backend "s3" {
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
    encrypt    = true
    bucket     = "fds-terraform-state"
    key        = "terraform.tfstate"
    region     = "us-east-1"
  }
}
