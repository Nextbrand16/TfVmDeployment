location                        = "uk south"
resource_group_name             = "rg_virt_machs"

vnet_name                       = "Vnet_core"
subnet_name                     = "sb_workload"
vnet_resource_group_name        = "RG_Vnet"

keyvault_name                   = "kv-vault003a"
#keyvault_resource_group_name    = "RG-KV"
#vm_admin_username_secret        = "vm-adminname"
vm_admin_password_secret        = "vm-adminpassword"
#vm_admin_username               = "adminuser"      # Replace with the actual admin username

vms = {
  "vm1" = {
    name       = "webserver1"
    size       = "Standard_B2s"
    os_disk_gb = 128
    tags       = { owner = "devops-team", role = "webserver", tier = "frontend" }
  },
  "vm2" = {
    name       = "webserver2"
    size       = "Standard_B2s"
    os_disk_gb = 128
    tags       = { role = "webserver", tier = "frontend" }
  }
  # ,
  # "vm3" = {
  #   name       = "appserver1"
  #   size       = "Standard_D2s_v3"
  #   os_disk_gb = 256
  #   tags       = { role = "appserver", tier = "backend" }
  # },
  # "vm4" = {
  #   name       = "database1"
  #   size       = "Standard_E2s_v3"
  #   os_disk_gb = 512
  #   tags       = { role = "database", tier = "backend" }
  # }
}

common_tags = {
  environment = "production"
  project     = "webapp"
  owner       = "devops-team"
}
