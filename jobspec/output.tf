output "vpc_cidr" {
  value = "${data.aws_vpc.vpc.cidr_block}"
}

output "nomad_server_ip" {
  value = "${data.aws_instance.nomad-server.private_ip}"
}

output "bastion_ip" {
  value = "${data.aws_instance.bastion.public_ip}"
}

/*
output "jobspec" {
  value = "${data.template_file.app_job_spec.rendered}"
}
*/