################        VPC        ################

# Private VPC to launch our test instances into
resource "aws_vpc" "vpc_1" {
  cidr_block                   = "${var.aws_private_vpc_cidr}"
  enable_dns_support           = true
  enable_dns_hostnames         = true

  tags = {
    Name                       = "${var.environment_name}_vpc_1"
  }
}


################   Route Tables    ################

# Route Table for EMR Instance
resource "aws_route_table" "rt_1" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"

  tags = {
    Name                       = "${var.environment_name}_rt_1"
  }
}


################      Subnets      ################

# Subnet 1a in Availability Zone A for Application Test Hosts
resource "aws_subnet" "sn_1a" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  cidr_block                   = "${var.aws_sn_1a_cidr}"
  availability_zone            = "${var.aws_region}a"
  map_public_ip_on_launch      = false

  tags = {
    Name                       = "${var.environment_name}_sn_1a"
  }
}

resource "aws_route_table_association" "rta_1a" {
  subnet_id                    = "${aws_subnet.sn_1a.id}"
  route_table_id               = "${aws_route_table.rt_1.id}"
}

# Subnet 1b in Availability Zone A for Application Test Hosts
resource "aws_subnet" "sn_1b" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  cidr_block                   = "${var.aws_sn_1b_cidr}"
  availability_zone            = "${var.aws_region}b"
  map_public_ip_on_launch      = false

  tags = {
    Name                       = "${var.environment_name}_sn_1b"
  }
}

resource "aws_route_table_association" "rta_1b" {
  subnet_id                    = "${aws_subnet.sn_1b.id}"
  route_table_id               = "${aws_route_table.rt_1.id}"
}

################  Security Groups  ################

# Security Group for Service Access
resource "aws_security_group" "sg_1" {
  name                         = "${var.environment_name}_sg_1"
  vpc_id                       = "${aws_vpc.vpc_1.id}"

  ingress {
    description                = "${var.environment_name}_sg_1 All within this SG"
    from_port                  = 0
    to_port                    = 0
    protocol                   = "-1"
    self                       = true
  }

  egress {
    description                = "${var.environment_name}_sg_1 All to Anywhere"
    from_port                  = 0
    to_port                    = 0
    protocol                   = "-1"
    cidr_blocks                = ["0.0.0.0/0"]
  }

  tags = {
    Name                       = "${var.environment_name}_sg_1"
  }
}

# Security Group for Private Access
resource "aws_security_group" "sg_2" {
  name                         = "${var.environment_name}_sg_2"
  vpc_id                       = "${aws_vpc.vpc_1.id}"

  ingress {
    description                = "${var.environment_name}_sg_2 All within this SG"
    from_port                  = 0
    to_port                    = 0
    protocol                   = "-1"
    self                       = true
  }

  ingress {
    description                = "${var.environment_name}_sg_2 HTTPS from sg_1"
    from_port                  = 0
    to_port                    = 0
    protocol                   = "-1"
    security_groups            = ["${aws_security_group.sg_1.id}"]
  }

  egress {
    description                = "${var.environment_name}_sg_2 All to Anywhere"
    from_port                  = 0
    to_port                    = 0
    protocol                   = "-1"
    cidr_blocks                = ["0.0.0.0/0"]
  }

  tags = {
    Name                       = "${var.environment_name}_sg_2"
  }
}


################  VPC Endpoints  ################


resource "aws_vpc_endpoint" "kinesis_streams" {
  # Kinesis is not availablein certain regions
  count                        = "${var.aws_region != "ap-southeast-2" ? 1 : 0}"
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  service_name                 = "com.amazonaws.${var.aws_region}.kinesis-streams"
  vpc_endpoint_type            = "Interface"
  subnet_ids                   = ["${aws_subnet.sn_1a.id}", "${aws_subnet.sn_1b.id}"]
  security_group_ids           = ["${aws_security_group.sg_1.id}", "${aws_security_group.sg_2.id}"]
  private_dns_enabled          = true
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  service_name                 = "com.amazonaws.${var.aws_region}.dynamodb"
  route_table_ids              = ["${aws_route_table.rt_1.id}"]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  service_name                 = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids              = ["${aws_route_table.rt_1.id}"]
}
