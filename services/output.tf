output "vpc_cidr" {
  value = "${data.aws_vpc.vpc.cidr_block}"
}
