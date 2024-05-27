variable "prefix" {
  default = "teamcity1"
}

resource "azurerm_resource_group" "teamcityResourceG" {
  name     = "${var.prefix}-resources"
  location = "eastus2"
}