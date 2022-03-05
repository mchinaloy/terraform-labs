terraform {
    backend "s3" {
        bucket = "terraform-labs-remote-state"
        key = "prod/terraform.tfstate"
        region = "eu-west-2"
    }
}
