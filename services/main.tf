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
  address = "https://nomad-${terraform.workspace}.${local.app_name}.${local.dns_zone}"
}

data "template_file" "prisma_config" {
  template = "${file("./tpl/prisma.config.tpl")}"
  vars {
    API_SECRET = "${data.aws_secretsmanager_secret_version.api_secret.secret_string}"
    DB_HOST = "${data.aws_db_instance.db.address}"
    DB_PORT = "3306"
    DB_USER = "prisma"
    DB_PASS = "${data.aws_secretsmanager_secret_version.db_password.secret_string}"
  }
}

data "template_file" "prisma_job_spec" {
  template = "${file("./tpl/prisma.hcl")}"
  vars {
    PRISMA_CONFIG = "${data.template_file.prisma_config.rendered}"
  }
}

resource "nomad_job" "prisma" {
  jobspec = "${data.template_file.prisma_job_spec.rendered}"
}

data "template_file" "backend_job_spec" {
  template = "${file("./tpl/backend.hcl")}"
  vars {
    JWT_SECRET = "${data.aws_secretsmanager_secret_version.jwt_secret.secret_string}"
    PRISMA_SECRET = "${data.aws_secretsmanager_secret_version.prisma_secret.secret_string}"
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
  vars {
    FLB_VERSION = "1.5.10"
    GO_VERSION = "1.11.1"
  }
}

resource "nomad_job" "flb" {
  jobspec = "${data.template_file.flb_job_spec.rendered}"
}

variable "LDAP_URL" {}
variable "LDAP_PRINCIPAL" {}
variable "LDAP_PASSWORD" {}
variable "LDAP_SEARCH_BASE" {}
variable "LDAP_SEARCH_FILTER" {}
