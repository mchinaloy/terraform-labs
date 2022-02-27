provider "aws" {
    region = "eu-west-2"
}

resource "null_resource" "command1" {
    provisioner "local-exec" {
      command = "echo Terraform START >> log.txt"
    }
}

resource "null_resource" "command2" {
    provisioner "local-exec" {
      command = "ping -c 5 www.google.com"
    }
}

resource "null_resource" "command3" {
    provisioner "local-exec" {
      interpreter = ["python", "-c"]
      command = "print('Hello World from Python')"
    }
}

resource "null_resource" "command4" {
    provisioner "local-exec" {
        command = "echo $NAME1 $NAME2"
        environment = {
          NAME1 = "Michael"
          NAME2 = "Mike"
      }
    }
}

resource "aws_instance" "myserver" {
    ami = "ami-0015a39e4b7c0966f"
    instance_type = "t2.micro"
    provisioner "local-exec" {
        command = "echo ${aws_instance.myserver.private_ip} >> log.txt"
    }
}

resource "null_resource" "command5" {
    provisioner "local-exec" {
      command = "echo Terraform FINISH >> log.txt"
    }
    depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4, aws_instance.myserver]
}
