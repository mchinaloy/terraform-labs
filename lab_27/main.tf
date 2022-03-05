provider "aws" {
    region = "eu-west-2"
}

resource "aws_instance" "node1" {
    ami = "ami-0015a39e4b7c0966f"
    instance_type = "t2.micro"
    tags = {
        Name = "Node-1"
        Owner = "Michael C"
    }
}

resource "aws_instance" "node2" {
    ami = "ami-0015a39e4b7c0966f"
    instance_type = "t2.micro"
    tags = {
        Name = "Node-2"
        Owner = "Michael C"
    }
}

resource "aws_instance" "node3" {
    ami = "ami-0015a39e4b7c0966f"
    instance_type = "t2.micro"
    tags = {
        Name = "Node-2"
        Owner = "Michael C"
    }
    depends_on = [
      aws_instance.node2
    ]
}
