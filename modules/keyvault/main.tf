resource "azurerm_key_vault" "keyvault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  #enabled_for_disk_encryption = true

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]
  }

  tags = var.tags

  # network_acls {
  #   default_action             = "Deny"
  #   bypass                     = "AzureServices"

  #   virtual_network_subnet_ids = [
  #     "/subscriptions/SUBSCRIPTION_ID_1/resourceGroups/RESOURCE_GROUP_NAME_1/providers/Microsoft.Network/virtualNetworks/VIRTUAL_NETWORK_NAME_1/subnets/SUBNET_NAME_1",
  #     "/subscriptions/SUBSCRIPTION_ID_2/resourceGroups/RESOURCE_GROUP_NAME_2/providers/Microsoft.Network/virtualNetworks/VIRTUAL_NETWORK_NAME_2/subnets/SUBNET_NAME_2",
  #     # Add more subnet resource IDs as needed
  #   ]
  # }
  
  
}

# resource "azurerm_key_vault_secret" "admin_username" {
#   name         = var.admin_username_secret_name
#   value        = var.admin_username
#   key_vault_id = azurerm_key_vault.keyvault.id
# }



resource "azurerm_key_vault_secret" "admin_password" {
  name         = var.admin_password_secret_name
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.keyvault.id
}
