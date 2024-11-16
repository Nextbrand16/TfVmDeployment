module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.common_tags
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.vnet_resource_group_name
}

data "azurerm_key_vault" "keyault" {
  name                = var.keyvault_name
  resource_group_name = "RG-KV"
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "password-secret-name"
  key_vault_id = data.azurerm_key_vault.keyault.id
}

module "common_tags" {
  source = "./modules/common_tags"
  tags   = var.common_tags
}

locals {
  Admin_password = data.azurerm_key_vault_secret.vm_admin_password.value
}

# main.tf
module "vm" {
  source   = "./modules/vm"
  for_each = var.vms

  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  snapshot_resource_group_name = each.value.snapshot_resource_group_name
  location                  = each.value.location
  size                      = each.value.size
  
  os_disk_snapshot_name     = each.value.os_disk_snapshot_name
  os_disk_type             = each.value.os_disk_type
  
  interfaces               = each.value.interfaces
  data_disks              = each.value.data_disks
  
  admin_username          = each.value.admin_username
  admin_password          = each.value.admin_password
  
  zone                    = each.value.zone
  tags                    = each.value.tags
}





# Data sources for Recovery Services vault and backup policy
# data "azurerm_recovery_services_vault" "example" {
#   name                = var.recovery_services_vault_name
#   resource_group_name = var.recovery_services_vault_resource_group_name
# }

# data "azurerm_backup_policy_vm" "example" {
#   name                = var.backup_policy_name
#   resource_group_name = data.azurerm_recovery_services_vault.example.resource_group_name
#   recovery_vault_name = data.azurerm_recovery_services_vault.example.name
#}

# # VM Backup configuration
# resource "azurerm_backup_protected_vm" "example" {
#   for_each = var.vms

#   resource_group_name = data.azurerm_recovery_services_vault.example.resource_group_name
#   recovery_vault_name = data.azurerm_recovery_services_vault.example.name
#   source_vm_id        = module.vm[each.key].vm_id
#   backup_policy_id    = data.azurerm_backup_policy_vm.example.id

#   depends_on = [module.vm]
# }



  module "azure_monitor" {
  source = "./modules/azure_monitor"

  action_groups         = var.action_groups
  metric_alerts         = var.metric_alerts
  #scheduled_query_rules = var.scheduled_query_rules
}

