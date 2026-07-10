variable "owner" {
  description = "Owner identifier (firstname-lastname, lowercase, hyphens)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]+[a-z0-9]$", var.owner))
    error_message = "owner must contain only lowercase letters, numbers and hyphens."
  }
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group to create"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "francecentral"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "tags" {
  description = "Additional tags to merge with the default tags"
  type        = map(string)
  default     = {}
}