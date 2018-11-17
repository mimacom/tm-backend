locals {
  app_name = "tm"
  dns_zone = "mimacom.solutions"
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

data "aws_secretsmanager_secret" "prisma_secret" {
  name = "${terraform.workspace}/prisma/secret"
}

data "aws_secretsmanager_secret_version" "prisma_secret" {
  secret_id = "${data.aws_secretsmanager_secret.prisma_secret.id}"
}

data "aws_secretsmanager_secret" "api_secret" {
  name = "${terraform.workspace}/api/secret"
}

data "aws_secretsmanager_secret_version" "api_secret" {
  secret_id = "${data.aws_secretsmanager_secret.api_secret.id}"
}

data "aws_secretsmanager_secret" "jwt_secret" {
  name = "${terraform.workspace}/jwt/secret"
}

data "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id = "${data.aws_secretsmanager_secret.jwt_secret.id}"
}

data "aws_db_instance" "db" {
  db_instance_identifier = "${local.app_name}-${terraform.workspace}-db"
}
