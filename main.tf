# Just comments and some global vars here

# refs: https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin/connect-your-cloud-platform-to-prisma-cloud/onboard-your-aws-account/set-up-your-aws-account#

# prisma-redlock.tf:  a terraform translation of the vendor provided cloudFormation template.
# cloudtrail.tf:      sets up the CloudTrail & CloudWatch portions of the instructions at refs:


data "aws_caller_identity" "current" {}

#generating a randome UUID to use as the external ID for the Prisma role
resource "random_uuid" "externalid" {}