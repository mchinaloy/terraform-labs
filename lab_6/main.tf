provider "aws" {
    region = "eu-west-2"
}

resource "aws_eip" "web" {
    instance = aws_instance.web.id
    tags = {
        Name = "WebServer built by Terraform"
        Owner = "Michael Chinaloy"
    }
}

resource "aws_instance" "web" {
    ami = "ami-0dd555eb7eb3b7c82" // Amazon Linux2
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.web.id]
    user_data = templatefile("user_data.sh.tpl", {
        f_name = "Michael"
        l_name = "Chinaloy"
        names = ["John", "Angel", "David", "Victor", "Frank", "Melissa", "Kitana"]
    })
    tags = {
        Name = "WebServer built by Terraform"
        Owner = "Michael Chinaloy"
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "web" {
    name = "WebServer-SG"
    description = "Security Group for my WebServer"
    ingress {
        description = "Allow port HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Allow port HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "Allow all ports"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "WebServer SG built by Terraform"
        Owner = "Michael Chinaloy"
    }
}