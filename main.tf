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
  name                = "administrativepword"
  resource_group_name = var.keyRG
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "password_secret_name"
  key_vault_id = data.azurerm_key_vault.keyault.id
}

module "common_tags" {
  source = "./modules/common_tags"
  tags   = var.common_tags
}

locals {
  Admin_password = data.azurerm_key_vault_secret.vm_admin_password.value
}

module "vm" {
  source   = "./modules/vm"
  for_each = var.vms

  name                = each.value.name
  size                = each.value.size
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = data.azurerm_subnet.subnet.id
  admin_username      = var.vm_username
  admin_password      = local.Admin_password
  os_disk_gb          = each.value.os_disk_gb
  data_disks          = each.value.data_disks
  tags                = merge(module.common_tags.tags, each.value.tags)

  depends_on = [module.resource_group]
}



# Data sources for Recovery Services vault and backup policy
data "azurerm_recovery_services_vault" "example" {
  name                = var.recovery_services_vault_name
  resource_group_name = var.recovery_services_vault_resource_group_name
}

data "azurerm_backup_policy_vm" "example" {
  name                = var.backup_policy_name
  resource_group_name = data.azurerm_recovery_services_vault.example.resource_group_name
  recovery_vault_name = data.azurerm_recovery_services_vault.example.name
}

# VM Backup configuration
resource "azurerm_backup_protected_vm" "example" {
  for_each = var.vms

  resource_group_name = data.azurerm_recovery_services_vault.example.resource_group_name
  recovery_vault_name = data.azurerm_recovery_services_vault.example.name
  source_vm_id        = module.vm[each.key].vm_id
  backup_policy_id    = data.azurerm_backup_policy_vm.example.id

  depends_on = [module.vm]