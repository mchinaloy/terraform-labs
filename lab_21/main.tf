provider "aws" {
  region = "eu-west-2"
}

resource "aws_iam_user" "user" {
  for_each = toset(var.aws_users)
  name = each.value
}

resource "aws_instance" "my_server" {
  for_each = toset(["Dev", "Staging", "Prod"])
  ami = "ami-0015a39e4b7c0966f"
  instance_type =  "t2.micro"
  tags = {
    Name = "Server-${each.value}"
    Owner = "Michael Chinaloy"
  }
}

resource "aws_instance" "my_dynamic_server" {
  for_each = var.servers_settings
  ami = each.value["ami"]
  instance_type = each.value["instance_type"]
  root_block_device {
    volume_size = each.value["root_disksize"]
    encrypted = each.value["encrypted"]
  }
  volume_tags = {
    "Name" = "Disk-${each.key}"
  }
  tags = {
    Name = "Server-${each.key}"
    Owner = "Michael Chinaloy"
  }
}

resource "aws_instance" "bastion" {
  for_each = var.create_bastion == "YES" ? toset(["bastion"]) : []
  ami = "ami-0015a39e4b7c0966f"
  instance_type =  "t2.micro"
  tags = {
    Name = "Bastion"
    Owner = "Michael Chinaloy"
  }
}
