variable "aws_region" {
    description = "Region where you want to provision this EC2 instance"
    type = string
    default = "eu-west-2"
}

variable "port_list" {
    description = "List of ports to open for our webserver"
    type = list(any)
    default = ["80", "443"]
}

variable "instance_size" {
    description = "Size of the instance"
    type = string
    default = "t2.micro"
}

variable "tags" {
    description = "Tags to apply to resources"
    type = map(any)
    default = {
        Owner = "Michael Chinaloy"
        Environment = "dev"
    }
}

variable "password" {
    description = "Please enter password length of 10 characters"
    type = string
    sensitive = true
    validation {
        condition = length(var.password) == 10
        error_message = "Password must be 10 characters exactly."
    }
}
