variable "environment_name" {
  description = "The name of the environment"
}

variable "aws_region" {
  description = "AWS region to create the VPC and services"
}

variable "aws_vpc_id" {
  description = "AWS VPC ID that the instances will be bound to"
}

variable "aws_security_group_id" {
  description = "AWS security group ID that the instances will be bound to"
}

variable "aws_subnet_id1" {
  description = "AWS subnet ID 1 that the workspaces directory can be bound to"
}

variable "aws_subnet_id2" {
  description = "AWS subnet ID 2 that the workspaces directory can be bound to"
}

variable "aws_directory_name" {
  description = "AWS workspaces active directory name"
}

variable "aws_directory_password" {
  description = "AWS workspaces active directory password"
}
