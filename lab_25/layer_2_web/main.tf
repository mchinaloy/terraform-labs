provider "aws" {
    region = "eu-west-2"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = merge(var.tags, { Name = "${var.env}-vpc" })
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = merge(var.tags, { Name = "${var.env}-igw" })
}

resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = element(var.public_subnet_cidrs, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        Name = "${var.env}-public-${count.index + 1}"
        Owner = "Michael Chinaloy"
    }
}

resource "aws_route_table" "public_subnet" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "${var.env}-route-public-subnets"
        Owner = "Michael Chinaloy"
    }
}

resource "aws_route_table_association" "public_routes" {
    count = length(aws_subnet.public_subnet[*].id)
    route_table_id = aws_route_table.public_subnet.id
    subnet_id = element(aws_subnet.public_subnet[*].id, count.index)
}

resource "aws_eip" "nat" {
    count = length(var.private_subnet_cidrs)
    vpc = true
    tags = merge(var.tags, { Name = "${var.env}-eip-${count.index + 1}" })
}

resource "aws_nat_gateway" "nat" {
    count = length(var.private_subnet_cidrs)
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.public_subnet[count.index].id
    tags = merge(var.tags, { Name = "${var.env}-nat-gw-${count.index + 1}" })
}

resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        Name = "${var.env}-private-${count.index + 1}"
        Owner = "Michael Chinaloy"
    }
}

resource "aws_route_table" "private_subnet" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "${var.env}-route-private-subnets"
        Owner = "Michael Chinaloy"
    }
}

resource "aws_route_table_association" "private_routes" {
    count = length(aws_subnet.private_subnet[*].id)
    route_table_id = aws_route_table.private_subnet.id
    subnet_id = aws_subnet.private_subnet.id[count.index].id
}

resource "aws_security_group" "web" {
    name = "WebServer-SG"
    description = "Security Group for my WebServer"
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
    }
    egress {
        description = "Allow all ports"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.env}-sg-web"
    }
}
