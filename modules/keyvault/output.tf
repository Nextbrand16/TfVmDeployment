output "keyvault_id" {
  value = azurerm_key_vault.keyvault.id
}

# output "admin_username_secret_id" {
#   value = azurerm_key_vault_secret.admin_username.id
# }

output "admin_password_secret_name" {
  value = azurerm_key_vault_secret.admin_password.name
}
