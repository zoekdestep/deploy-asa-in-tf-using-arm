variable "location" {
  type        = string
  description = "Azure region where to create resources"
  default     = "West Europe"
}

variable "administrator_login" {
  type        = string
  description = "SQL server administrator login"
  default     = "msadministrator"
  sensitive   = true
}

