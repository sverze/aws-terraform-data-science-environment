
variable "environment_name" {
  description = "The name of the environment"
  default     = "data_science_dev"
}

variable "aws_region" {
  description      = "AWS region to create the VPC and services"
  default          = "eu-west-1"
}

variable "aws_profile" {
  description      = "AWS profile to use other during provisioning"
}

variable "aws_private_vpc_cidr" {
  description      = "VPC CIDR block range for the private VPC"
  default          = "10.1.0.0/16"
}

variable "aws_sn_1a_cidr" {
  description      = "Subnet availability zone A CIDR block range for bastion instance"
  default          = "10.1.1.0/24"
}

variable "aws_sn_1b_cidr" {
  description      = "Subnet availability zone B CIDR block range for bastion instance"
  default          = "10.1.2.0/24"
}

variable "aws_directory_name" {
  description      = "Active directory domain name - this will not be registered"
  default          = "com.data.science"
}

variable "aws_directory_password" {
  description      = "Active directory password used for administration"
}
