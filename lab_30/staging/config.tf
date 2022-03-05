terraform {
    backend "s3" {
        bucket = "terraform-labs-remote-state"
        key = "staging/terraform.tfstate"
        region = "eu-west-2"
    }
}
