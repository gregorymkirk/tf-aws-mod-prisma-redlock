#Create the Pisma RedLock role (translated from the CloudFormation Template)

resource "aws_iam_role" "prisma_cloud" {
  name               = "awc-nit-iam-role-Prisma"
  assume_role_policy = templatefile("${path.module}/policies/PrismaCloud-IAM-AssumeRole.json", { EXTERNALID = random_uuid.externalid.result })
  path               = "/core/"
}

resource "aws_iam_role_policy_attachment" "security_audit" {
  role       = "${aws_iam_role.prisma_cloud.id}"
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_policy" "read_only" {
  path        = "/core/"
  name        = "PrismaCloud-IAM-ReadOnly-Policy"
  description = "PrismaCloud-IAM-ReadOnly-Policy"
  policy      = file("${path.module}/policies/PrismaCloud-IAM-ReadOnly-Policy.json")
}

resource "aws_iam_role_policy_attachment" "read_only" {
  role       = "${aws_iam_role.prisma_cloud.id}"
  policy_arn = "${aws_iam_policy.read_only.arn}"
}

resource "aws_iam_policy" "read_write" {
  count       = var.read_write
  path        = "/core/"
  name        = "PrismaCloud-IAM-Remediation-Policy"
  description = "PrismaCloud-IAM-Remediation-Policy"
  policy      = file("${path.module}/policies/PrismaCloud-IAM-Remediation-Policy.json")
}

resource "aws_iam_role_policy_attachment" "read_write" {
  count      = var.read_write
  role       = "${aws_iam_role.prisma_cloud.id}"
  policy_arn = "${aws_iam_policy.read_write[0].arn}"
}


