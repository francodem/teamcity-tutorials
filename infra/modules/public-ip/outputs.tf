output "public-ip-1-id" {
  value = azurerm_public_ip.teamcityVMPublicIP1.id
}

output "public-ip-2-id" {
  value = azurerm_public_ip.teamcityVMPublicIP2.id
}

output "public-ip-address-from1" {
  value = azurerm_public_ip.teamcityVMPublicIP1.ip_address
}

output "public-ip-address-from2" {
  value = azurerm_public_ip.teamcityVMPublicIP2.ip_address
}