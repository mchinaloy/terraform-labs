variable "env" {
    default = "dev"
}

variable "server_size" {
    default = {
        dev = "t2.micro"
        my_default = "t2.micro"
    }
}

variable "ami_id_per_region" {
    description = "My Custom AMI id per Region"
    default = {
        "eu-west-1" = "ami-0dd555eb7eb3b7c82"
        "eu-west-2" = "ami-0015a39e4b7c0966f"
    }
}

variable "allow_port" {
    default = {
        prod = ["80", "443"]
        my_default = ["80", "443", "8080", "22"]
    }
}
