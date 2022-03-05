provider "aws" {
    region = "eu-west-2"
}

data "aws_ami" "latest_amazonlinux" {
    owners = ["137112412989"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "web" {
    ami = data.aws_ami.latest_amazonlinux.id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.web.id]
    user_data = <<EOF
        #!/bin/bash
        yum -y update
        yum -y install httpd
        MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
        echo "<h2>WebServer with PrivateIP: $MYIP</h2><br>Built by Terraform" > /var/www/html/index.html
        service httpd start
        chkconfig httpd on
    EOF
    tags = {
        Name = "Webserver ${terraform.workspace}"
        Owner = "Michael C"
    }
}

resource "aws_security_group" "web" {
    name_prefix = "WebServer-SG"
    description = "Security Group for my WebServer"
    ingress {
        description = "Allow port HTTP"
        from_port = 80
        to_port = 80
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
        Name = "WebServer SG ${terraform.workspace}"
        Owner = "Michael Chinaloy"
    }
}

resource "aws_eip" "web" {
    instance = aws_instance.web.id
    tags = {
        Name = "WebServer ${terraform.workspace}"
        Owner = "Michael Chinaloy"
    }
}
