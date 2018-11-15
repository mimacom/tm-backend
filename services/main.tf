terraform {
  backend "s3" {
    encrypt                 = false
    bucket                  = "mimacom-tm-terraform-state"
    dynamodb_table          = "terraform-state-lock"
    region                  = "eu-central-1"
    key                     = "services"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "mimacom"
  }
}

provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "mimacom"
}

provider "nomad" {
  address = "http://${data.aws_alb.nomad.dns_name}:4646"
}

/*
data "template_file" "prisma_job_spec" {
  template = "${file("./tpl/prisma.hcl")}"
  vars {
    DB_HOST = "${data.aws_db_instance.db.address}"
    DB_PASS = "${data.aws_secretsmanager_secret_version.db_password.secret_string}"
  }
}


resource "nomad_job" "prisma" {
  jobspec = "${data.template_file.prisma_job_spec.rendered}"
}

*/

data "template_file" "backend_job_spec" {
  template = "${file("./tpl/backend.hcl")}"
  vars {
    JWT_SECRET = "${data.aws_secretsmanager_secret_version.app_secret.secret_string}"
    ENV = "${terraform.workspace}"
    LDAP_URL = "${var.LDAP_URL}"
    LDAP_PRINCIPAL = "${var.LDAP_PRINCIPAL}"
    LDAP_PASSWORD = "${var.LDAP_PASSWORD}"
    LDAP_SEARCH_BASE = "${var.LDAP_SEARCH_BASE}"
    LDAP_SEARCH_FILTER = "${var.LDAP_SEARCH_FILTER}"
  }
}

resource "nomad_job" "backend" {
  jobspec = "${data.template_file.backend_job_spec.rendered}"
}

data "template_file" "flb_job_spec" {
  template = "${file("./tpl/flb.hcl")}"
}

resource "nomad_job" "flb" {
  jobspec = "${data.template_file.flb_job_spec.rendered}"
}

variable "LDAP_URL" {}
variable "LDAP_PRINCIPAL" {}
variable "LDAP_PASSWORD" {}
variable "LDAP_SEARCH_BASE" {}
variable "LDAP_SEARCH_FILTER" {}
