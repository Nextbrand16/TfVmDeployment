variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "vms" {
  description = "Map of VM configurations"
  type = map(object({
    name        = string
    size        = string
    os_disk_gb = number
    tags       = map(string)
  }))
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = { environment = "production" }
}

variable "vnet_name" {
  description = "Name of the existing VNet"
  type        = string
}

variable "subnet_name" {
  description = "Name of the existing Subnet"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing Resource Group"
  type        = string
}

variable "keyvault_name" {
  description = "Name of the existing Key Vault"
  type        = string
}

variable "vm_admin_username_secret" {
  description = "Name of the secret for VM admin username"
  type        = string
}

variable "vm_admin_password_secret" {
  description = "Name of the secret for VM admin password"
  type        = string
}

variable "vnet_resource_group_name" {
  description = "Name of the existing Resource Group"
  type        = string
}

variable "keyvault_resource_group_name" {
  description = "Name of the existing Resource Group"
  type        = string
}