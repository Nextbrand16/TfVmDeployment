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

data "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_resource_group_name
}

data "azurerm_key_vault_secret" "vm_admin_username" {
  name         = var.vm_admin_username_secret
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = var.vm_admin_password_secret
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

module "common_tags" {
  source = "./modules/common_tags"
  tags   = var.common_tags
}

module "vm" {
  source   = "./modules/vm"
  for_each = var.vms

  name                = each.value.name
  size                = each.value.size
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = data.azurerm_subnet.subnet.id
  admin_username      = var.vm_admin_username_secret
  admin_password      = data.azurerm_key_vault_secret.vm_admin_password.value
  os_disk_gb          = each.value.os_disk_gb
  tags                = merge(module.common_tags.tags, each.value.tags)

  depends_on = [module.resource_group]
}

