provider "aws" {
    region = "eu-west-2"
}

resource "aws_instance" "servers" {
    count = 3
    ami = "ami-0015a39e4b7c0966f"
    instance_type = "t2.micro"
    tags = {
        Name = "Server number ${count.index}"
        Owner = "Michael Chinaloy"
    }
}

resource "aws_iam_user" "users" {
    count = length(var.aws_users)
    name = element(var.aws_users, count.index)
}

resource "aws_instance" "bastion" {
    count = var.create_bastion == "YES" ? 1 : 0
    ami = "ami-0015a39e4b7c0966f"
    instance_type = "t2.micro"
    tags = {
        Name = "BastionsServer"
        Owner = "Michael Chinaloy"
    }
}
