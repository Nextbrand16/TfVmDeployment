variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "object_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

# variable "admin_username_secret_name" {
#   type = string
# }

# variable "admin_username" {
#   type = string
# }

variable "admin_password_secret_name" {
  type = string
}

variable "admin_password" {
  type = string
}
