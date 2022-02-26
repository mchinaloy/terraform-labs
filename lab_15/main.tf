provider "aws" {
    region = var.aws_region
}

data "aws_ami" "latest_amazonlinux" {
    owners = ["137112412989"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

resource "aws_eip" "web" {
    instance = aws_instance.web.id
    tags = merge(var.tags, { Name = "${var.tags["Environment"]} EIP for WebServer built by Terraform" })
}

resource "aws_instance" "web" {
    ami = data.aws_ami.latest_amazonlinux.id
    instance_type = var.instance_size
    vpc_security_group_ids = [aws_security_group.web.id]
    user_data = file("user_data.sh")
    tags = merge(var.tags, { Name = "${var.tags["Environment"]} WebServer built by Terraform" })
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "web" {
    name = "WebServer-SG"
    description = "Security Group for my WebServer"
    dynamic "ingress" {
        for_each = var.port_list
        content {
            description = "Allow port HTTP"
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
    egress {
        description = "Allow all ports"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = merge(var.tags, { Name = "${var.tags["Environment"]} WebServer SG built by Terraform" })
}
