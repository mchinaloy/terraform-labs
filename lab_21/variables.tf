variable "aws_users" {
    description = "List of IAM users to create"
    default = [
        "michael.chinaloy1@dev.com",
        "michael.chinaloy2@dev.com",
        "michael.chinaloy3@dev.com",
        "michael.chinaloy4@dev.com"
    ]
}

variable "servers_settings" {
    default = {
        web = {
            ami = "ami-0015a39e4b7c0966f"
            instance_type = "t2.micro"
            root_disksize = 10
            encrypted = true
        }
        app = {
            ami = "ami-0015a39e4b7c0966f"
            instance_type = "t2.micro"
            root_disksize = 10
            encrypted = true
        }
    }
}

variable "create_bastion" {
    default = "YES"
}
