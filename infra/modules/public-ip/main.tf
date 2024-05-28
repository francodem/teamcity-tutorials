variable "prefix" {
  default = "teamcity"
}

variable "resource-group-location" {
  type = string
}

variable "resource-group-name" {
  type = string
}

resource "azurerm_public_ip" "teamcityVMPublicIP1" {
  name                = "${var.prefix}-pool-pub-ip1"
  resource_group_name = var.resource-group-name
  location            = var.resource-group-location
  allocation_method   = "Static"

  tags = {
    environment = "dev"
  }
}

# resource "azurerm_public_ip" "teamcityVMPublicIP2" {
#   name                = "${var.prefix}-pool-pub-ip2"
#   resource_group_name = var.resource-group-name
#   location            = var.resource-group-location
#   allocation_method   = "Static"

#   tags = {
#     environment = "dev"
#   }
# }