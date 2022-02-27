provider "aws" {
    region = "eu-west-2"
}

provider "aws" {
    region = "eu-south-1"
    alias = "DEV"
    assume_role {
      role_arn = "arn:xxx"
    }
}

resource "aws_vpc" "master_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Master VPC"
    }
}

resource "aws_vpc" "dev_vpc" {
    provider = aws.DEV
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "DEV VPC"
    }
}
