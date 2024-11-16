variable "name" {
  type        = string
  description = "Name of the virtual machine"
}

variable "resource_group_name" {
  type        = string
  description = "Target resource group name"
}

variable "snapshot_resource_group_name" {
  type        = string
  description = "Resource group name where snapshots are stored"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "size" {
  type        = string
  description = "Size of the virtual machine"
}

variable "os_disk_snapshot_name" {
  type        = string
  description = "Name of the OS disk snapshot"
}

variable "os_disk_type" {
  type        = string
  description = "Storage account type for OS disk"
  default     = "Standard_LRS"
}

variable "interfaces" {
  type = list(object({
    name                = string
    ip_config_name     = string
    subnet_id          = string
    private_ip_address = optional(string)
  }))
  description = "Network interface configurations"
}

variable "data_disks" {
  type = list(object({
    name                = string
    snapshot_name       = string
    storage_account_type = string
    lun                 = number
  }))
  description = "Data disk configurations with snapshot names"
  default     = []
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password for the VM"
}

variable "zone" {
  type        = string
  description = "Availability zone number"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to all resources"
  default     = {}
}