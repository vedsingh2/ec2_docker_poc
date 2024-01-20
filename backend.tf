terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # backend "s3" {
  #   bucket         = "<bucketname>"
  #   region         = "eu-west-1"
  #   key            = "app.tfstate"
  #   dynamodb_table = "<tablename>-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::533267126918:role/tfmServiceUser"
  }
}
