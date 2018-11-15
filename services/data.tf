locals {
  app_name = "tm"
}

data "aws_vpc" "vpc" {
  tags {
    Name = "${local.app_name}-${terraform.workspace}"
  }
}

data "aws_secretsmanager_secret" "db_password" {
  name = "${terraform.workspace}/db/password"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "${data.aws_secretsmanager_secret.db_password.id}"
}

data "aws_secretsmanager_secret" "app_secret" {
  name = "${terraform.workspace}/jwt/secret"
}

data "aws_secretsmanager_secret_version" "app_secret" {
  secret_id = "${data.aws_secretsmanager_secret.app_secret.id}"
}

data "aws_db_instance" "db" {
  db_instance_identifier = "${local.app_name}-${terraform.workspace}-db"
}

data "aws_alb" "nomad" {
  name = "${local.app_name}-${terraform.workspace}-nomad"
}
