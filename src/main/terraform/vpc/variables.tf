
variable "environment_name" {
    description = "The name of the environment"
}

variable "aws_region" {
  description = "AWS region to create the VPC and services"
}

variable "aws_profile" {
  description = "AWS profile to use other during provisioning"
}

variable "aws_private_vpc_cidr" {
  description = "VPC CIDR block range for the private VPC"
}

variable "aws_sn_1a_cidr" {
  description = "Subnet availability zone A CIDR block range for DS network"
}

variable "aws_sn_1b_cidr" {
  description = "Subnet availability zone B CIDR block range for DS network"
}
