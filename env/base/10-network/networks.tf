resource "azurerm_virtual_network" "econcloud" {
  name                = "eConCloud-network-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.econcloud.name
  address_space       = ["172.26.0.0/19"]
}

# 172.26.16.0/24 (subnetaks on DEV)

resource "azurerm_subnet" "subnetarchivestorage" {
  name                 = "subnet_archive_storage"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.17.0/24"]

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_subnet" "subnetdocgenstorage" {
  name                 = "subnet_docgen_storage"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.18.0/25"]
  private_link_service_network_policies_enabled = false
  
  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_subnet" "subnetwfstorage" {
  name                 = "subnet_wf_control"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.18.128/25"]

  delegation {
    name = "ACIDelegationService"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "subnetaksaci" {
  name                 = "subnet_aks_aci"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.19.0/24"]

  delegation {
    name = "ACIDelegationService"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "subnetocrcontrol" {
  name                 = "subnet_ocr_control"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.20.0/26"]
}
resource "azurerm_subnet" "subnetocrdb" {
  name                 = "subnet_ocr_db"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.20.64/26"]

  private_endpoint_network_policies = "Disabled"
}
resource "azurerm_subnet" "subnetocrprocess" {
  name                 = "subnet_ocr_process"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.20.128/25"]
}

resource "azurerm_subnet" "subnetesignprocess" {
  name                 = "subnet_esign_process"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.21.0/25"]
}
resource "azurerm_subnet" "subnetesignstorage" {
  name                 = "subnet_esign_storage"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.21.128/26"]
}
resource "azurerm_subnet" "subnetesigndb" {
  name                 = "subnet_esign_db"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.21.192/26"]

  private_endpoint_network_policies = "Disabled"
}
resource "azurerm_subnet" "subnetaks" {
  name                 = "subnet_aks"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.16.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# 172.26.24.0/24
# 172.26.25.0/24
# 172.26.26.0/24
# 172.26.27.0/24
# 172.26.28.0/24

resource "azurerm_subnet" "subnetpostgres1" {
  name                 = "subnet_postgres1"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.29.0/26"]

  private_endpoint_network_policies = "Disabled"
  service_endpoints = (var.environment == "prod") ? [] : ["Microsoft.Storage","Microsoft.AzureCosmosDB"]
}

resource "azurerm_subnet" "subnetpostgres2" {
  name                 = "subnet_postgres2"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.29.64/26"]

  delegation {
    name = "postgreSQLDelegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
  service_endpoints = (var.environment == "prod") ? ["Microsoft.Storage"] : ["Microsoft.Storage","Microsoft.AzureCosmosDB"]
}

# 172.26.29.128/26
# 172.26.29.192/26

resource "azurerm_subnet" "subnetprivateendpoints" {
  name                 = "subnet_privateendpoints"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.30.0/24"]

  private_endpoint_network_policies = "Disabled"
  service_endpoints = (var.environment == "prod") ? [] : ["Microsoft.Storage","Microsoft.AzureCosmosDB"]
}

resource "azurerm_subnet" "subnetmgmt" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.econcloud.name
  resource_group_name  = azurerm_resource_group.econcloud.name
  address_prefixes     = ["172.26.31.0/24"]
}

# resource "azurerm_subnet" "subnetekycsa" {
#   name                 = "subnet_ekyc_storage"
#   virtual_network_name = azurerm_virtual_network.econcloud.name
#   resource_group_name  = azurerm_resource_group.econcloud.name
#   address_prefixes     = var.ekyc_subnet_cidr

#   enforce_private_link_endpoint_network_policies = true
# }