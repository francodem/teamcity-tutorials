variable "prefix" {
  default = "teamcity2"
}

variable "resource-group-id" {
  type = string
}

variable "resource-group-location" {
  type = string
}

variable "resource-group-name" {
  type = string
}

variable "network-interface-2-id" {
  type = string
}

resource "azurerm_virtual_machine" "teamcityMain2" {
  name                  = "${var.prefix}-vm2"
  location              = var.resource-group-location
  resource_group_name   = var.resource-group-name
  network_interface_ids = [ var.network-interface-2-id ]
  vm_size               = "Standard_B2s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk2828"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "teamcity-pool-2"
    admin_username = "ubuntu"
    admin_password = "Francoadmin1!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "teamcity-pool-2"
  }
}