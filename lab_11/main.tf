provider "aws" {
    region = "eu-west-2"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "working" {}

resource "aws_vpc" "dev" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "dev"
    }
}

data "aws_vpc" "dev" {
    tags = {
        Name = "dev"
    }
    depends_on = [
      aws_vpc.dev
    ]
}

resource "aws_subnet" "subnet1" {
    vpc_id     = aws_vpc.dev.id
    cidr_block = "10.0.1.0/24"
    availability_zone = data.aws_availability_zones.working.names[0]
    tags = {
        Name = "Subnet-1"
        Info = "AZ: ${data.aws_availability_zones.working.names[0]} in Region: ${data.aws_region.current.name}"
    }
    depends_on = [
      aws_vpc.dev
    ]
}

resource "aws_subnet" "subnet2" {
    vpc_id     = aws_vpc.dev.id
    cidr_block = "10.0.2.0/24"
    availability_zone = data.aws_availability_zones.working.names[1]
    tags = {
        Name = "Subnet-2"
        Info = "AZ: ${data.aws_availability_zones.working.names[0]} in Region: ${data.aws_region.current.name}"
    }
    depends_on = [
      aws_vpc.dev
    ]
}

output "region_name" {
    value = data.aws_region.current.name
}

output "region_description" {
    value = data.aws_region.current.description
}

output "account_id" {
    value = data.aws_caller_identity.current.account_id
}

output "availability_zones" {
    value = data.aws_availability_zones.working.names
}
