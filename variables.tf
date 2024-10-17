variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "vnet_resource_group_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}

# variable "keyvault_resource_group_name" {
#   type = string
# }

# variable "tenant_id" {
#   type = string
# }

# variable "object_id" {
#   type = string
# }

# variable "vm_admin_username_secret" {
#   type = string
# }

variable "vm_admin_password_secret" {
  type = string
}

# variable "keyRG" {
#   type = string
# }

variable "vm_username" {
  type = string
}

# variable "vm_admin_username" {
#   type = string
# }

variable "common_tags" {
  type = map(string)
}

variable "vms" {
  type = map(object({
    name        = string
    size        = string
    os_disk_gb  = number
    # data_disks  = list(object({
    #   disk_size_gb = number
    # }))
    tags        = map(string)
  }))
}


variable "Admin_password" {
  type = string
  default = null
  sensitive = true
}

/*
variable "recovery_services_vault_name" {
  description = "Name of the existing Recovery Services vault"
  type        = string
}



variable "recovery_services_vault_resource_group_name" {
  description = "Resource group name of the existing Recovery Services vault"
  type        = string
}

variable "backup_policy_name" {
  description = "Name of the existing backup policy"
  type        = string
}
*/

#Variables for Root Module (variables.tf)

variable "action_groups" {
  description = "Action groups configuration"
  type = map(object({
    name                = string
    resource_group_name = string
    short_name          = string
    email_receivers = list(object({
      name  = string
      email = string
    }))
    tags = map(string)
  }))
}


variable "metric_alerts" {
  description = "Metric alerts configuration"
  type = map(object({
    name                = string
    resource_group_name = string
    scopes              = list(string)
    description         = string
    frequency           = string
    window_size         = string
    severity            = number
    target_resource_type = string
    target_resource_location = string
    criteria = list(object({
      metric_namespace = string
      metric_name      = string
      aggregation      = string
      operator         = string
      threshold        = number
    }))
    action_group_ids = list(string)
    tags             = map(string)
  }))
}

/*
variable "scheduled_query_rules" {
  description = "Scheduled query rules configuration"
  type = map(object({
    name                = string
    resource_group_name = string
    description         = string
    frequency           = string
    severity            = number
    data_source_id      = string
    query               = string
    action_group_ids    = list(string)
    tags                = map(string)
  }))
}
*/