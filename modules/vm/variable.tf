variable "name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "location" {
  description = "The location of the virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID for the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
}

variable "os_disk_gb" {
  description = "The size of the OS disk in GB"
  type        = number
}

variable "data_disks" {
  description = "List of data disks configurations"
  type = list(object({
    disk_size_gb = number
  }))
  default = []
}

variable "tags" {
  description = "Tags to be applied to the resources"
  type        = map(string)
}
