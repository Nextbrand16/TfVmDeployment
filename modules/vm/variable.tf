variable "name" {
  description = "VM name"
  type        = string
}

variable "size" {
  description = "VM size"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "admin_username" {
  description = "VM admin username"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "VM admin password"
  type        = string
  sensitive   = true
}

variable "os_disk_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 128
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}