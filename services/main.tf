provider "nomad" {
  address = "http://${data.aws_instance.nomad-server.private_ip}:4646"
}

data "template_file" "prisma_job_spec" {
  template = "${file("./tpl/prisma.hcl")}"
  vars {
    DB_HOST = "${data.aws_db_instance.db.address}"
    DB_PASS = "${data.aws_secretsmanager_secret_version.db_password.secret_string}"
  }
}

data "template_file" "backend_job_spec" {
  template = "${file("./tpl/backend.hcl")}"
  vars {
    APP_SECRET = "${data.aws_secretsmanager_secret_version.app_secret.secret_string}"
    ENV = "${terraform.workspace == "dev" ? ".dev" : ""}"
    LDAP_URL = "${var.LDAP_URL}"
    LDAP_PRINCIPAL = "${var.LDAP_PRINCIPAL}"
    LDAP_PASSWORD = "${var.LDAP_PASSWORD}"
    LDAP_SEARCH_BASE = "${var.LDAP_SEARCH_BASE}"
    LDAP_SEARCH_FILTER = "${var.LDAP_SEARCH_FILTER}"
  }
}

data "template_file" "flb_job_spec" {
  template = "${file("./tpl/flb.hcl")}"
}

resource "nomad_job" "prisma" {
  jobspec = "${data.template_file.prisma_job_spec.rendered}"
}

resource "nomad_job" "backend" {
  jobspec = "${data.template_file.backend_job_spec.rendered}"
}

resource "nomad_job" "flb" {
  jobspec = "${data.template_file.flb_job_spec.rendered}"
}

variable "LDAP_URL" {}
variable "LDAP_PRINCIPAL" {}
variable "LDAP_PASSWORD" {}
variable "LDAP_SEARCH_BASE" {}
variable "LDAP_SEARCH_FILTER" {}
