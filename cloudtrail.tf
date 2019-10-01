#Enable Flow logs for Prisma
resource "aws_iam_role" "prisma_flowlogs" {
  name               = "awc-nit-iam-role-PrismaFlowLogs"
  assume_role_policy = file("${path.module}/policies/PrismaCloud-IAM-FlogLogsAssumeRole-policy.json")
  path               = "/core/"
}


resource "aws_cloudwatch_log_group" "prisma" {
  name = "awc-nit-sw-log-group-Prisma"
  tags = {}
}

#Grab a list of the VPCs and turn on the flow logs for them
data "aws_vpcs" "local" {}

resource "aws_flow_log" "prisma" {
  count           = "${length(data.aws_vpcs.local.ids)}"
  iam_role_arn    = "${aws_iam_role.prisma_flowlogs.arn}"
  log_destination = "${aws_cloudwatch_log_group.prisma.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${element( tolist(data.aws_vpcs.local.ids), count.index)}"
}

#versioning is on to catch attempts to modify the logs.
#a modified log entry should have more than one version.
resource "aws_s3_bucket" "prisma" {
  bucket     = "prisma-cloudtrail-logs-${data.aws_caller_identity.current.account_id}"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled = var.lifecycle_enabled
    expiration  {
      days = var.expiration
    }
    transition {
      days          = var.archive
      storage_class = var.archive_class
    }
  }
}

resource "aws_s3_bucket_policy" "prisma" {
  bucket = "${aws_s3_bucket.prisma.id}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": { "Service": "cloudtrail.amazonaws.com" },
            "Action": "*",
            "Resource": "${aws_s3_bucket.prisma.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": { "Service": "cloudtrail.amazonaws.com" },
            "Action": "s3:PutObject",
            "Resource":  "${aws_s3_bucket.prisma.arn}/redlock/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
  POLICY
}

resource "aws_iam_role" "prisma-cloudtrail" {
  name               = "awc-nit-iam-role-Prisma-cloudtrail"
  assume_role_policy = file("${path.module}/policies/CloudTrail-IAM-AssumeRole.json")
  path               = "/core/"
}

resource "aws_iam_policy" "prisma-cloudtrail" {
  path        = "/core/"
  name        = "PrismaCloudTrailServiceRolePolicy"
  description = "PrismaCloudTrailServiceRolePolicy"
  policy      = file("${path.module}/policies/CloudTrail-Role-Policy.json")
}

resource "aws_iam_role_policy_attachment" "prisma-cloudtrail" {
  role       = "${aws_iam_role.prisma-cloudtrail.id}"
  policy_arn = "${aws_iam_policy.prisma-cloudtrail.arn}"
}

resource "aws_cloudtrail" "prisma" {
  name                          = "awc-nit-cloudtrail-Prisma"
  enable_logging                = true
  s3_bucket_name                = "${aws_s3_bucket.prisma.id}"
  s3_key_prefix                 = "redlock"
  include_global_service_events = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.prisma.arn
  cloud_watch_logs_role_arn  = aws_iam_role.prisma-cloudtrail.arn
}

