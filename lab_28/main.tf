provider "aws" {
    region = "eu-west-2"
}

resource "aws_instance" "node1" {
    instance_type = "t2.micro"
    ami = "ami-0dd555eb7eb3b7c82"
    tags = {
        Name = "chainlink-bastion"
    }
}

resource "aws_instance" "node2" {
    instance_type = "t2.medium"
    ami = "ami-0dd555eb7eb3b7c82"
    tags = {
        Name = "chainlink-node"
    }
}
