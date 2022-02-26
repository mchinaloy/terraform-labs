provider "aws" {
    region = "eu-west-2"
}

resource "aws_db_instance" "dev" {
    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    db_name              = "mydb"
    username             = "foo"
    password             = data.aws_secretsmanager_secret_version.rds_password.secret_string
    parameter_group_name = "default.mysql5.7"
    skip_final_snapshot  = true
}

resource "random_password" "main" {
    length = 20
    special = true
    override_special = "#!()_"
}

resource "aws_secretsmanager_secret" "rds_password" {
    name = "/dev/rds/password"
    description = "Password my RDS database"
    recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_password" {
    secret_id = aws_secretsmanager_secret.rds_password.id
    secret_string = random_password.main.result
}

resource "aws_secretsmanager_secret" "rds" {
    name = "/dev/rds/all"
    description = "All details for my RDS database"
    recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds" {
    secret_id = aws_secretsmanager_secret.rds.id
    secret_string = jsonencode({
        rds_address = aws_db_instance.dev.address
        rds_port = aws_db_instance.dev.port
        rds_username = aws_db_instance.dev.username
        rds_password = aws_db_instance.dev.password
    })
}

data "aws_secretsmanager_secret_version" "rds_password" {
    secret_id = aws_secretsmanager_secret.rds_password.id
    depends_on = [aws_secretsmanager_secret_version.rds_password]
}

data "aws_secretsmanager_secret_version" "rds" {
    secret_id = aws_secretsmanager_secret.rds.id
    depends_on = [aws_secretsmanager_secret_version.rds]
}

output "rds_address" {
    value = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["rds_address"]
}

output "rds_port" {
    value = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["rds_port"]
}

output "rds_username" {
    value = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["rds_username"]
}

output "rds_password" {
    value = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["rds_password"]
    sensitive = true
}

output "rds_all" {
    value = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)
}