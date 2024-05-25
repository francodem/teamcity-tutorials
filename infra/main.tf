terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# ------------------------
# Resources
# ------------------------

variable "prefix" {
  default = "teamcity"
}

resource "azurerm_resource_group" "teamcityResourceG" {
  name     = "${var.prefix}-resources"
  location = "eastus2"
}

resource "azurerm_virtual_network" "teamcityMain" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.teamcityResourceG.location
  resource_group_name = azurerm_resource_group.teamcityResourceG.name
}

resource "azurerm_public_ip" "teamcityVMPublicIP" {
  name                = "teamcity-pool-pub-ip"
  resource_group_name = azurerm_resource_group.teamcityResourceG.name
  location            = azurerm_resource_group.teamcityResourceG.location
  allocation_method   = "Static"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "teamcityInternal" {
  name                 = "teamcity-internal"
  resource_group_name  = azurerm_resource_group.teamcityResourceG.name
  virtual_network_name = azurerm_virtual_network.teamcityMain.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "teamcityNetworkInterface" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.teamcityResourceG.location
  resource_group_name = azurerm_resource_group.teamcityResourceG.name

  ip_configuration {
    name                          = "teamcity-config"
    subnet_id                     = azurerm_subnet.teamcityInternal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.teamcityVMPublicIP.id
  }
}

resource "azurerm_virtual_machine" "teamcityMain" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.teamcityResourceG.location
  resource_group_name   = azurerm_resource_group.teamcityResourceG.name
  network_interface_ids = [azurerm_network_interface.teamcityNetworkInterface.id]
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
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "teamcity-pool-1"
    admin_username = "ubuntu"
    admin_password = "Francoadmin1!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "teamcity-pool"
  }
}

output "vm-pool-dns" {
  value = azurerm_public_ip.teamcityVMPublicIP.ip_address
}