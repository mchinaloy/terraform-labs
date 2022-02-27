provider "aws" {
    region = "eu-west-2"
}

resource "aws_iam_user" "user" {
    for_each = toset(var.aws_users)
    name = each.value
}

resource "aws_instance" "my_server" {
    count = 3
    ami = ""
    instance_type = "t2.micro"
    tags = {
        Name = "Server-${count.index + 1}"
        Owner = "Michael Chinaloy"
    }
}


