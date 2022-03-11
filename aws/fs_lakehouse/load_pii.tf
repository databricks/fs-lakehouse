resource "databricks_dbfs_file" "this" {
  content_base64 = base64encode(<<-EOT
Name|SSN|Credit_Card_Number|Card_Type
Robert Aragon|489-36-8350|4929-3813-3266-4295|Visa MC AMEX
Ashley Borden|514-14-8905|5370-4638-8881-3020|Visa MC AMEX
Thomas Conley|690-05-5315|4916-4811-5814-8111|Visa MC AMEX
    EOT
  )
  path = "/tmp/pii.csv"
}