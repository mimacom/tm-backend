provider "aws" {
  region = "eu-central-1"
  shared_credentials_file = "~/.aws/credentials"
  profile = "mimacom"
}

data "aws_vpc" "vpc" {
  tags {
    Name = "tm-${terraform.workspace}"
  }
}

data "aws_secretsmanager_secret" "dbpass_secret" {
  name = "${terraform.workspace}/db/password"
}

data "aws_secretsmanager_secret_version" "data" {
  secret_id = "${data.aws_secretsmanager_secret.dbpass_secret.id}"
}

data "aws_db_instance" "db" {
  db_instance_identifier = "tm-${terraform.workspace}-db"
}

data "aws_instance" "nomad-server" {
  instance_tags {
    Name = "tm-${terraform.workspace}-server"
  }
}
data "aws_instance" "bastion" {
  instance_tags {
    Name = "tm-${terraform.workspace}-bastion"
  }
}

output "vpc_cidr" {
  value = "${data.aws_vpc.vpc.cidr_block}"
}

output "nomad_server_ip" {
  value = "${data.aws_instance.nomad-server.private_ip}"
}

output "bastion_ip" {
  value = "${data.aws_instance.bastion.public_ip}"
}

provider "nomad" {
  address = "http://${data.aws_instance.nomad-server.private_ip}:4646"
}

data "template_file" "job_spec" {
  template = "${file("./backend.nomad")}"
  vars {
    DB_HOST = "${data.aws_db_instance.db.address}"
    DB_PASS = "${data.aws_secretsmanager_secret_version.data.secret_string}"
  }
}

resource "nomad_job" "backend" {
  jobspec = "${data.template_file.job_spec.rendered}"
}