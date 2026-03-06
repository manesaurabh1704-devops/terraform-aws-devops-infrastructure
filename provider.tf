provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {

    bucket         = "saurabh-terraform-state-devops"
    key            = "terraform-project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true

  }
}
