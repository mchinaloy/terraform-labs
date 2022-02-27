provider "aws" {
    region = "eu-west-2"
}

module "my_vpc_prod" {
    source = "../modules/aws_network"
    env = "prod"
    vpc_cidr = "10.100.0.0/16"
    public_subnet_cidrs = ["10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24"]
    private_subnet_cidrs = ["10.200.11.0/24", "10.200.22.0/24", "10.200.33.0/24"]
}

module "server_standalone" {
    source = "../modules/aws_testserver"
    name = "MICHAEL-IT"
    message = "Standalone Server"
    subnet_id = module.my_vpc_prod.public_subnet_ids[2]
}

module "servers_loop_count" {
    source = "../modules/aws_testserver"
    count = length(module.my_vpc_prod.public_subnet_ids)
    name = "MICHAEL-IT"
    message = "Hello from server in subnt ${module.my_vpc_prod.public_subnet_ids[count.index]} created by COUNT loop"
    subnet_id = module.my_vpc_prod.public_subnet_ids[count.index]
}

module "servers_loop_foreach" {
    source = "../modules/aws_testserver"
    for_each = toset(module.my_vpc_prod.public_subnet_ids)
    name = "MICHAEL-IT"
    message = "Hello from server in subnt ${each.value} created by FOR_EACH loop"
    subnet_id = each.value
    depends_on = [module.servers_loop_count]
}
