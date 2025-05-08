terraform {
  backend "azurerm" {
    resource_group_name  = "rg-econ-prod-state"
    storage_account_name = "steconprodstate"
    container_name       = "stceconprodstate"
    key                  = "30-storage.tfstate"
  }
}
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}
locals {
  rgname_eternal = var.environment == "prod" ? "${var.prefix}cloud-resources-eternal" : "eConCloud-resources-eternal"
  rgname         = "${var.prefix}cloud-resources-${var.environment}"
  vnetname       = "eConCloud-network-${var.environment}"
  subscription_id = var.environment == "prod" ? "b1877428-9f0d-4124-8b87-4bbf1af6a484" : "7f2b9a96-2609-4bc1-aec0-de68d59e6d1b"
}
data "azurerm_subnet" "subnetprivateendpoints" {
  name                 = "subnet_privateendpoints"
  virtual_network_name = local.vnetname
  resource_group_name  = local.rgname
}
data "azurerm_subnet" "subnetdocgenstorage" {
  name                 = "subnet_docgen_storage"
  virtual_network_name = local.vnetname
  resource_group_name  = local.rgname
}
data "azurerm_subnet" "subnetarchivestorage" {
  name                 = "subnet_archive_storage"
  virtual_network_name = local.vnetname
  resource_group_name  = local.rgname
}
data "azurerm_subnet" "subnetesignstorage" {
  name                 = "subnet_esign_storage"
  virtual_network_name = local.vnetname
  resource_group_name  = local.rgname
}
data "azurerm_private_dns_zone" "storacctfileprivatelink" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = local.rgname
}
data "azurerm_private_dns_zone" "storageblobprivatelink" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.rgname
}

# ------------------
# Shared storage for installers etc.
# ------------------
resource "azurerm_storage_account" "storaccountinstallers" {
  name                     = "${var.prefix}storage${var.environment}"
  resource_group_name      = local.rgname_eternal
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  allow_nested_items_to_be_public  = false
  blob_properties {
    container_delete_retention_policy {
      days = 7
    }
  }
  #  azure_files_authentication = {
  #      directory_type = "AADDS"
  #  }
  #  tags = {
  #    environment = ${lower(var.environment)}
  #  }
}
# ------------------
# installers container (Crowdstrike AV etc.)
# ------------------
resource "azurerm_storage_container" "installers" {
  name                  = "installers"
  storage_account_name  = azurerm_storage_account.storaccountinstallers.name
  container_access_type = "private"
}
# ------------------
# Auditlog container (eSign MSSQL, OCR MSSQL)
# ------------------
resource "azurerm_storage_container" "auditlogs" {
  name                  = "audit${var.environment}"
  storage_account_name  = azurerm_storage_account.storaccountinstallers.name
  container_access_type = "private"
}


resource "azurerm_storage_account" "storaccountmonitoring" {
  name                = "${var.prefix}monitorstorage${var.environment}"
  resource_group_name = local.rgname
  location            = var.location
  account_tier        = "Premium"
  #Whether this shoudl LRS/ZRS[I need to check with Kartrine or Holger/ replication latency and Cost concern]/GRS[Ruled out]
  account_replication_type = "LRS"
  # Need to check with the TLS because of old Application.
  min_tls_version          = "TLS1_2"
  account_kind             = "BlockBlobStorage"
  public_network_access_enabled = contains(["devm"], var.environment) ? false : true
  cross_tenant_replication_enabled = var.environment == "devm" ? false : true
  #Versioning is not enabled(Do we need to enable?)
  allow_nested_items_to_be_public  = false
  blob_properties {
    # delete_retention_policy {
    #   days = 7
    # }
    container_delete_retention_policy {
      days = 7
    }
  }
  tags = {
      "Application" = "Shared"
    }
}
resource "azurerm_private_endpoint" "privateEPmonitoring" {
  name                = "${var.prefix}monitor-storage${var.environment}-endpoint"
  resource_group_name = local.rgname
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnetprivateendpoints.id

  private_service_connection {
    name                           = "${var.prefix}monitor-storage${var.environment}-serviceconnection"
    private_connection_resource_id = azurerm_storage_account.storaccountmonitoring.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
resource "azurerm_storage_container" "loki" {
  name                  = "loki"
  storage_account_name  = azurerm_storage_account.storaccountmonitoring.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "tempo" {
  name                  = "tempo"
  storage_account_name  = azurerm_storage_account.storaccountmonitoring.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "thanos" {
  name                  = "thanos"
  storage_account_name  = azurerm_storage_account.storaccountmonitoring.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "aksLogStorageAcc" {
  name                     = "${var.prefix}akslogsto${var.environment}"
  resource_group_name      = local.rgname_eternal
  location                 = var.location
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"
  account_replication_type = "LRS"
}

module "StorageAccount" {
  source        = "../../../modules/infra_modules/StorageAccount"
  tags          = var.common_tags
  location      = var.location
  prefix        = "econ"
  environment   = var.environment
}


 # #--------------------Camunda Storage Account--------------------#
resource "azurerm_storage_account" "appworksstorage" {
  name                     = "${var.prefix}appworksa${var.environment}"
  resource_group_name       = local.rgname
  location                  = var.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "ZRS"
  min_tls_version           = "TLS1_2"
  access_tier               = "Hot"
  # public_network_access_enabled = "false"    //This attribute is unsupported in tf (1.1.7)version but required in upgraded version
#   enable_https_traffic_only = false
  tags                      = var.tags
  network_rules {
    default_action = "Allow"
    bypass         = [
     "AzureServices",
    ]
    ip_rules       = []
  }
  share_properties {
    retention_policy {
      days = 7
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "sa_diagnostics1" {
   name               = "appwork-sa-${var.environment}-diagnostic"
   target_resource_id = azurerm_storage_account.appworksstorage.id
   storage_account_id = azurerm_storage_account.appworksstorage.id
   metric {
     category = "Transaction"
     enabled = true

     retention_policy {
       days = 0
       enabled = false
     }
   }
   metric {
     category = "Capacity"
     enabled = false

     retention_policy {
       days = 0
       enabled = false
     }
   }
 }

resource "azurerm_storage_share" "appworksstoragefileshare" {
  name                 = "fsocr"
  storage_account_name = azurerm_storage_account.appworksstorage.name
  quota                = 50 # size in GiB Mandatory to give
}

resource "azurerm_storage_share" "appworksstoragefileshareidha" {
  name                 = "idha"
  storage_account_name = azurerm_storage_account.appworksstorage.name
  quota                = 50 # size in GiB Mandatory to give
}

resource "azurerm_storage_share" "appworksstoragefileshareesign" {
  name                 = "esign"
  storage_account_name = azurerm_storage_account.appworksstorage.name
  quota                = 50 # size in GiB Mandatory to give
}


# #--------------------OCR Storage Account--------------------#
resource "azurerm_storage_account" "ocrmwcstorage" {
  count = var.environment == "prod" ? 1 : 0
  name                     = "${var.prefix}ocrmwc${var.environment}"
  resource_group_name       = local.rgname
  location                  = var.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "ZRS"
  min_tls_version           = "TLS1_2"
  access_tier               = "Hot"
  #public_network_access_enabled = "false"    //This attribute is unsupported in tf (1.1.7)version but required in upgraded version
#   enable_https_traffic_only = "false"
  tags                      = var.tags
  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
    ip_rules       = []
  }
  share_properties {
    retention_policy {
      days = 7
    }
  }
}
##----- Create a Storage Container ---------##
resource "azurerm_storage_container" "ocrmwccontainer" {
  count = var.environment == "prod" ? 1 : 0
  name                  = "mwc"
  storage_account_name  = azurerm_storage_account.ocrmwcstorage[0].name
  container_access_type = "private" # Options: private, blob, container
}
