provider "aws" {
    region = "eu-west-2"
}

resource "aws_instance" "web" {
    ami = "ami-0c9bfc21ac5bf10eb"
    instance_type = "t2.micro"
}
