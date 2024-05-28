variable "prefix" {
  default = "teamcity"
}

variable "azure-resource-group-location" {
  type = string
}

variable "azure-resource-group-name" {
  type = string
}

variable "public-ip-1-id" {
  type = string
}

variable "public-ip-2-id" {
  type = string
}

resource "azurerm_virtual_network" "teamcityMain" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.azure-resource-group-location
  resource_group_name = var.azure-resource-group-name
}

resource "azurerm_subnet" "teamcityInternal" {
  name                 = "teamcity-internal"
  resource_group_name  = var.azure-resource-group-name
  virtual_network_name = azurerm_virtual_network.teamcityMain.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "teamcityNetworkInterface1" {
  name                = "${var.prefix}-nic1"
  location            = var.azure-resource-group-location
  resource_group_name = var.azure-resource-group-name

  ip_configuration {
    name                          = "teamcity-config"
    subnet_id                     = azurerm_subnet.teamcityInternal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.public-ip-1-id
  }
}

# resource "azurerm_network_interface" "teamcityNetworkInterface2" {
#   name                = "${var.prefix}-nic2"
#   location            = var.azure-resource-group-location
#   resource_group_name = var.azure-resource-group-name

#   ip_configuration {
#     name                          = "teamcity-config"
#     subnet_id                     = azurerm_subnet.teamcityInternal.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = var.public-ip-2-id
#   }
# }