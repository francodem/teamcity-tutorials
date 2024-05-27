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
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# ------------------------
# Resources
# ------------------------

module "resource-group" {
  source = "./modules/rg"
}

module "public-ip" {
  source = "./modules/public-ip"
  resource-group-location = module.resource-group.resource-group-location
  resource-group-name = module.resource-group.resource-group-name
}

output "public-ip-1" {
  description = "The public ip address from vm1."
  value = module.public-ip.public-ip-address-from1
}

output "public-ip-2" {
  description = "The public ip address from vm2."
  value = module.public-ip.public-ip-address-from2
}

module "virtual-network" {
  source = "./modules/vn"
  azure-resource-group-location = module.resource-group.resource-group-location
  azure-resource-group-name = module.resource-group.resource-group-name
  public-ip-1-id = module.public-ip.public-ip-1-id
  public-ip-2-id = module.public-ip.public-ip-2-id
}

module "vm-1" {
  source = "./modules/vm1"
  resource-group-id = module.resource-group.resource-group-id
  resource-group-location = module.resource-group.resource-group-location
  resource-group-name = module.resource-group.resource-group-name
  network-interface-1-id = module.virtual-network.azure-netrowk-interface-1-id
}

module "vm-2" {
  source = "./modules/vm2"
  resource-group-id = module.resource-group.resource-group-id
  resource-group-location = module.resource-group.resource-group-location
  resource-group-name = module.resource-group.resource-group-name
  network-interface-2-id = module.virtual-network.azure-netrowk-interface-2-id
}