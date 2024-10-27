terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "aslam-tf-state"
    region         = "us-east-1"
    key            = "tf-state"
    dynamodb_table = "aslam-state-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "aslamcodes123456"
}
