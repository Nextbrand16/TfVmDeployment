resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "${var.name}-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "data_disks" {
  for_each             = { for idx, disk in var.data_disks : idx => disk }
  name                 = format("%s-datadisk-%d", var.name, each.key)
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  disk_size_gb         = each.value.disk_size_gb
  create_option        = "Empty"
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = var.tags

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = try(var.os_disk_gb, 128)
    name                 = format("%s-osdisk", var.name)
  }

  # dynamic "data_disk" {
  #   for_each = azurerm_managed_disk.data_disks
  #   content {
  #     lun             = each.key
  #     caching         = "ReadOnly"
  #     managed_disk_id = each.value.id
  #   }
  # }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  depends_on = [azurerm_network_interface.nic]
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachments" {
  for_each = { for idx, disk in var.data_disks : idx => disk }

  managed_disk_id    = azurerm_managed_disk.data_disks[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = each.key
  caching            = "ReadOnly"
}