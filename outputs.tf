output "AccountID" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "PrismaCloud_role_name" {
  value = "${aws_iam_role.prisma_cloud.name}"
}

output "PrismaCloud_role_ARN" {
  value = "${aws_iam_role.prisma_cloud.arn}"
}

output "PrismaCloud_role_external_id" {
  value = "${random_uuid.externalid.result}"
}