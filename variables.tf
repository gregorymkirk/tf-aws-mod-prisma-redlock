variable read_write {
  description = "Enable remediation features 1 = yes, 0 = no"
  default     = 0
}

# logs can consume a lot of data which can get expensice
# defaults are confugred to keep 90 days at top tier, and delte the data after 2 years

variable lifecycle_enabled {
  description = "Lifecycle rules enabled"
  default     = true
}

variable archive {
  description = "Number of days before archiving logs to lower tier storage"
  default     = 90
}

variable expiration {
  description = "Number of days before expiring/deleting log data"
  default    = 731
}

variable archive_class {
  description = "The S3 storage class to use for archived data valid values are: ONEZONE_IA, STANDARD_IA, INTELLIGENT_TIERING, GLACIER, or DEEP_ARCHIVE."
  default     = "DEEP_ARCHIVE"
}

