data "aws_ami" "latest_amazonlinux" {
    owners = ["137112412989"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

data "aws_subnet" "web" {
    id = var.subnet_id
}

resource "aws_instance" "web_server" {
    instance_type = "t2.micro"
    ami = data.aws_ami.latest_amazonlinux.id
    subnet_id = var.subnet_id
    user_data = <<EOF
        #!/bin/bash
        yum -y update
        yum -y install httpd
        myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
        cat <<HTMLTEXT > /var/www/html/index.html
        <h2>
        ${var.name} WebServer with IP: $myip <br>
        ${var.name} WebServer in AZ: ${data.aws_subnet.web.availability_zone}<br>
        Message:</h2> ${var.message}
        HTMLTEXT
        service httpd start
        chkconfig httpd on
    EOF
    tags = {
        Name = "Default Server"
    }
}

resource "aws_security_group" "web" {
    name = "My-Security-Group"
    vpc_id = data.aws_subnet.web.vpc_id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "Allow ALL ports"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "SG by Terraform"
        Owner = "Michael Chinaloy"
    }
}
