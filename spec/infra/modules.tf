module "base_network" {
  source = "git@github.com:tobyclemson/terraform-aws-base-networking.git//src"

  vpc_cidr = "${var.vpc_cidr}"
  region = "${var.region}"
  availability_zones = "${var.availability_zones}"

  component = "${var.component}"
  deployment_identifier = "${var.deployment_identifier}"

  bastion_ami = "${var.bastion_ami}"
  bastion_ssh_public_key_path = "${var.bastion_ssh_public_key_path}"
  bastion_ssh_allow_cidrs = "${var.bastion_ssh_allow_cidrs}"

  domain_name = "${var.domain_name}"
  public_zone_id = "${var.public_zone_id}"
  private_zone_id = "${var.private_zone_id}"
}

module "ecs_load_balancer" {
  source = "../../src"

  component = "${var.component}"
  deployment_identifier = "${var.deployment_identifier}"

  region = "${var.region}"
  vpc_id = "${module.base_network.vpc_id}"
  public_subnet_ids = "${module.base_network.public_subnet_ids}"
  private_subnet_ids = "${module.base_network.private_subnet_ids}"

  service_name = "${var.service_name}"
  service_port = "${var.service_port}"

  service_certificate_arn = "${aws_iam_server_certificate.service.arn}"

  domain_name = "${var.domain_name}"
  public_zone_id = "${var.public_zone_id}"
  private_zone_id = "${var.private_zone_id}"

  elb_internal = "${var.elb_internal}"
  elb_health_check_target = "${var.elb_health_check_target}"
  elb_https_allow_cidrs = "${var.elb_https_allow_cidrs}"
}
