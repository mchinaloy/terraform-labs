variable "aws_users" {
    description = "List of IAM users to create"
    default = [
        "michael1.chinaloy@dev.com",
        "michael2.chinaloy@dev.com",
        "michael3.chinaloy@dev.com",
        "michael4.chinaloy@dev.com"
    ]
}

variable "create_bastion" {
    description = "Provision a Bastion Server YES/NN"
    default = "YES"
}
