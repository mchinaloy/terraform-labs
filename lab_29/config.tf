terraform {
    backend "s3" {
        bucket = "terraform-labs-remote-state"
        key = "dev/terraform.tfstate"
        region = "eu-west-2"
    }
}
