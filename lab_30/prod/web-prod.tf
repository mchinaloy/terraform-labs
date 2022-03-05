resource "aws_instance" "web-prod" {
    ami = data.aws_ami.latest_amazonlinux.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.web-prod.id]
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
        Name = "Webserver Prod"
        Owner = "Michael C"
    }
}

resource "aws_security_group" "web-prod" {
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
        Name = "WebServer SG Prod"
        Owner = "Michael Chinaloy"
    }
}
