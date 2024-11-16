# Data source for OS disk snapshot
data "azurerm_snapshot" "os_disk" {
  name                = var.os_disk_snapshot_name
  resource_group_name = var.snapshot_resource_group_name
}

# Data sources for data disk snapshots
data "azurerm_snapshot" "data_disks" {
  for_each = {
    for disk in var.data_disks : disk.snapshot_name => disk
  }
  name                = each.value.snapshot_name
  resource_group_name = var.snapshot_resource_group_name
}

# Network Interface
resource "azurerm_network_interface" "this" {
  for_each = { for k, v in var.interfaces : v.name => merge(v, { index = k }) }

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = each.value.ip_config_name
    subnet_id                     = each.value.subnet_id
    private_ip_address            = try(each.value.private_ip_address, null)
    private_ip_address_allocation = try(each.value.private_ip_address, null) != null ? "Static" : "Dynamic"
  }

  tags = var.tags
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  zone                = var.zone

  network_interface_ids = [for v in var.interfaces : azurerm_network_interface.this[v.name].id]

  os_disk {
    name                 = format("%s-osdisk", var.name)
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = data.azurerm_snapshot.os_disk.disk_size_gb
  }

  # Use snapshot for OS disk
  source_image_id = data.azurerm_snapshot.os_disk.id

  tags = var.tags

  lifecycle {
    ignore_changes = [
      os_disk,
      admin_password,
    ]
  }
}

# Managed Data Disks from Snapshots
resource "azurerm_managed_disk" "this" {
  for_each = {
    for disk in var.data_disks : disk.name => disk
  }

  name                 = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  storage_account_type = each.value.storage_account_type
  create_option       = "Copy"
  source_resource_id  = data.azurerm_snapshot.data_disks[each.value.snapshot_name].id
  disk_size_gb        = data.azurerm_snapshot.data_disks[each.value.snapshot_name].disk_size_gb
  zone                = var.zone
  tags                = var.tags
}

# Data Disk Attachments
resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each           = {
    for disk in var.data_disks : disk.name => disk
  }
  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.this.id
  lun                = each.value.lun
  caching            = "ReadWrite"
}