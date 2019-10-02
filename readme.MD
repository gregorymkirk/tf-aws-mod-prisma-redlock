#TF-MOD-PRISMA-REDLOCK

##Introduction

This module implements all the configuration steps at (including those perfromed by the cloudformatin template):

(https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin/connect-your-cloud-platform-to-prisma-cloud/onboard-your-aws-account/set-up-your-aws-account#)

This moduled can be used to speed and simplify the Prisma onboarding process, and can be integrated with account provisiining steps to ensure that the account can be onboarded at launch.

##Usage Instructions and Sample Code:

Variables in the sample code are all at their defautl values (see variables.tf).

If these values are acceptable, then you can call the module in your code with only the source specified.

```
module "prisma" {
  source = "<path to module>"
  # For read only implementation set this to 0
  # To allow remediation set this to 1
  read_write = 0

  # Enables the S3 storage lifecycle rules, recmomdned to true as log storage can get expensive quickly
  # Ensure lifecycle rules will meet any compliance needs you are subject to.
  lifecycle_enabled  = true

  # Settings for the lifecycle rules
  # Number of days before archiving the record to lower tier storage 
  archive  = 90
  # Tier of storage to use for archiving
  archive_class = "DEEP_ARCHIVE"

  #Number of days before expiring the record (default 2 years, accounting for leap years)
  expiration = 731  
}
```

##Author and revision history

Author: Gregory Kirk
Contact: gkirk@smartronix.com
v 0.1 : initial working versin 02OCT2019
