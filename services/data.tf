provider "aws" {
  region = "eu-central-1"
  shared_credentials_file = "~/.aws/credentials"
  profile = "mimacom"
}

terraform {
  backend "s3" {
    encrypt                 = false
    bucket                  = "mimacom-tm-tfstate"
    dynamodb_table          = "terraform-state-lock-dynamo"
    region                  = "eu-central-1"
    key                     = "services"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "mimacom"
  }
}

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
  name = "${terraform.workspace}/app/secret"
}

data "aws_secretsmanager_secret_version" "app_secret" {
  secret_id = "${data.aws_secretsmanager_secret.app_secret.id}"
}

data "aws_db_instance" "db" {
  db_instance_identifier = "${local.app_name}-${terraform.workspace}-db"
}

data "aws_instance" "nomad-server" {
  instance_tags {
    Name = "server"
    Environment = "${terraform.workspace}"
    Application = "${local.app_name}"
  }
}

data "aws_instance" "bastion" {
  instance_tags {
    Name = "bastion-host"
    Environment = "${terraform.workspace}"
    Application = "${local.app_name}"
  }
}
