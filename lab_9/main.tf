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
    password             = data.aws_ssm_parameter.rds_password.value
    parameter_group_name = "default.mysql5.7"
    skip_final_snapshot  = true
}

resource "random_password" "main" {
    length = 20
    special = true
    override_special = "#!()_"
}

resource "aws_ssm_parameter" "rds_password" {
  name  = "/dev/dev-mysql-rds/password"
  description = "Master password for RDS database"
  type  = "SecureString"
  value = random_password.main.result
}

data "aws_ssm_parameter" "rds_password" {
    name = "/dev/dev-mysql-rds/password"
    depends_on = [aws_ssm_parameter.rds_password]
}

output "rds_address" {
    value = aws_db_instance.dev.address
}

output "rds_port" {
    value = aws_db_instance.dev.port
}

output "rds_username" {
    value = aws_db_instance.dev.username
}

output "rds_password" {
    value = aws_db_instance.dev.password
    sensitive = true
}
