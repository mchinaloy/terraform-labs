provider "aws" {
    region = "eu-west-2"
}

provider "aws" {
    region = "eu-south-1"
    alias = "MILAN"
}

data "aws_ami" "latest_amazonlinux" {
    provider = aws.MILAN
    owners = ["137112412989"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "my_default_server" {
    provider = aws.MILAN
    instance_type = "t2.micro"
    ami = data.aws_ami.latest_amazonlinux.id
    tags = {
        Name = "Default Server"
    }
}
