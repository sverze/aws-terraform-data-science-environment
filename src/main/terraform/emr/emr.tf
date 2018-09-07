################  EMR Roles & Policies ################


data "template_file" "user_data" {
  template                            = "${file("${path.module}/user-data.sh")}"
}

resource "aws_iam_role" "emr_iam_role" {
  name                                = "emr_iam_role"

  assume_role_policy                  =
<<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticmapreduce.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_instance_profile" "emr_iam_instance_profile" {
  name                                = "emr_iam_instance_profile"
  role                                = "${aws_iam_role.emr_iam_role.name}"
}

resource "aws_iam_role_policy" "iam_emr_service_policy" {
  name                                = "iam_emr_service_policy"
  role                                = "${aws_iam_role.emr_iam_role.id}"

  policy                              = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
            "ec2:*",
            "iam:GetRole",
            "iam:GetRolePolicy",
            "iam:ListInstanceProfiles",
            "iam:ListRolePolicies",
            "iam:PassRole",
            "s3:CreateBucket",
            "s3:Get*",
            "s3:List*",
            "sdb:BatchPutAttributes",
            "sdb:Select",
            "sqs:CreateQueue",
            "sqs:*"
        ]
    }]
}
EOF
}

################  EMR Spark Cluster  ################


resource "aws_emr_cluster" "emr_cluster" {
  name                                = "${var.environment_name}_cluster"
  release_label                       = "emr-4.6.0"
  applications                        = ["Spark"]
  termination_protection              = false
  keep_job_flow_alive_when_no_steps   = true

  ec2_attributes {
    subnet_id                         = "${var.aws_subnet_id}"
    service_access_security_group     = "${var.aws_service_security_group_id}"
    emr_managed_master_security_group = "${var.aws_private_security_group_id}"
    emr_managed_slave_security_group  = "${var.aws_private_security_group_id}"
    instance_profile                  = "${aws_iam_instance_profile.emr_iam_instance_profile.arn}"
  }

  instance_group {
    instance_count = 1
    instance_role = "MASTER"
    instance_type = "m3.xlarge"
  }

  instance_group {
    instance_count = 2
    instance_role = "CORE"
    instance_type = "m3.xlarge"
  }

  # master_instance_type                = "m3.xlarge"
  # instance_group                      = [${aws_emr_instance_group.emr_instance_group}]

  tags {
    role                              = "${aws_iam_role.emr_iam_role.name}"
    env                               = "${var.environment_name}"
    name                              = "${var.environment_name}_cluster"
  }

  # bootstrap_action {
  #   path = "s3://elasticmapreduce/bootstrap-actions/run-if"
  #   name = "runif"
  #   args = ["instance.isMaster=true", "echo running on master node"]
  # }
  #
  # configurations = "test-fixtures/emr_configurations.json"

  service_role                       = "${aws_iam_role.emr_iam_role.arn}"
}
