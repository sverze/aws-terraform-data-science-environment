provider "aws" {
  region                        = "${var.aws_region}"
  profile                       = "${var.aws_profile}"
}

# Sets up the entire network including gateways
module "aws_vpc" {
  source                        = "./vpc"
  environment_name              = "${var.environment_name}"
  aws_region                    = "${var.aws_region}"
  aws_profile                   = "${var.aws_profile}"
  aws_private_vpc_cidr          = "${var.aws_private_vpc_cidr}"
  aws_sn_1a_cidr                = "${var.aws_sn_1a_cidr}"
  aws_sn_1b_cidr                = "${var.aws_sn_1b_cidr}"
}

# Bastion host accessible from the public subnet
module "workspaces" {
  source                        = "./workspaces"
  environment_name              = "${var.environment_name}"
  aws_region                    = "${var.aws_region}"
  aws_vpc_id                    = "${module.aws_vpc.vpc_1_id}"
  aws_security_group_id         = "${module.aws_vpc.sg_1_id}"
  aws_subnet_id1                = "${module.aws_vpc.sn_1a_id}"
  aws_subnet_id2                = "${module.aws_vpc.sn_1b_id}"
  aws_directory_name            = "${var.aws_directory_name}"
  aws_directory_password        = "${var.aws_directory_password}"
}

# EMR cluster used for testing
#module "emr" {
#  source                        = "./emr"
#  environment_name              = "${var.environment_name}"
#  aws_region                    = "${var.aws_region}"
#  aws_profile                   = "${var.aws_profile}"
#  aws_service_security_group_id = "${module.aws_vpc.sg_1_id}"
#  aws_private_security_group_id = "${module.aws_vpc.sg_2_id}"
#  aws_vpc_id                    = "${module.aws_vpc.vpc_1_id}"
#  aws_subnet_id                 = "${module.aws_vpc.sn_1a_id}"
#  aws_ami                       = "${lookup(var.aws_amis, var.aws_region)}"
#}
