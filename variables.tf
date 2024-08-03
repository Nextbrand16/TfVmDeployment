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

variable "tenant_id" {
  type = string
}

variable "object_id" {
  type = string
}

# variable "vm_admin_username_secret" {
#   type = string
# }

variable "vm_admin_password_secret" {
  type = string
}

variable "keyRG" {
  type = string
}

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
    data_disks  = list(object({
      disk_size_gb = number
    }))
    tags        = map(string)
  }))
}


variable "Admin_password" {
  type = string
  default = null
  sensitive = true
}

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