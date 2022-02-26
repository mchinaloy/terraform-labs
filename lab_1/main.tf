# Lab 1
provider "aws" {
    region = "eu-west-2"    
}

resource "aws_instance" "my_ubuntu" {
    ami = "ami-0015a39e4b7c0966f"
    instance_type = "t2.micro"
    key_name = "ec2-tutorial"

    tags = {
        Name = "My-Ubuntu-Server"
        Owner = "Michael Chinaloy"
        project = "Phoenix"
    }
}

resource "aws_instance" "my_amazon_linux" {
    ami = "ami-0dd555eb7eb3b7c82"
    instance_type = "t2.micro"
    key_name = "ec2-tutorial"

    tags = {
        Name = "My-Amazon-Linux-Server"
        Owner = "Michael Chinaloy"
    }
}