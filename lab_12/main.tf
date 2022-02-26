provider "aws" {
    region = "eu-west-2"
}

# resource "aws_instance" "myserver" {
#     ami = data.aws_ami.latest_ubuntu20.id
#     instance_type = ""
# }

data "aws_ami" "latest_amazonlinux" {
    owners = ["137112412989"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

data "aws_ami" "latest_ubuntu20" {
    owners = ["067508366995"]
    most_recent = true
    filter {
        name = "name"
        values = ["Public_Bluebox_Base-*"]
    }
}

output "latest_amazonlinux_ami_id" {
    value = data.aws_ami.latest_amazonlinux.id
}

output "latest_ubuntu20_ami_id" {
    value = data.aws_ami.latest_ubuntu20.id
}
