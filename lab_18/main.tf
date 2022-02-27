provider "aws" {
    region = "eu-west-2"
}

resource "aws_instance" "myserver" {
    ami = "ami-0015a39e4b7c0966f"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.web.id]
    key_name = "terraform-labs"
    tags = {
        Name = "My EC2 with remote-exec"
        Owner = "Michael Chinaloy"
    }

    provisioner "remote-exec" {
      inline = [
        "mkdir /home/ec2-user/terraform",
        "cd /home/ec2-user/terraform",
        "touch hello.txt",
        "echo 'Terraform was here...' > terraform.txt"
      ]
      connection {
        type = "ssh"
        user = "ec2-user"
        host = self.public_ip
        private_key = file("terraform-labs.cer")
      }
    }
}

resource "aws_security_group" "web" {
    name = "My-Security-Group"
    ingress {
        from_port = 22
        to_port = 22
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
