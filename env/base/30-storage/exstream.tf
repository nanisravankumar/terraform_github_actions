# ------------------
# EXSTREAM hotfolder
# ------------------
resource "azurerm_storage_account" "econexstreamnfs" {
  name                      = "${var.prefix}exstreamnfs${var.environment}"
  resource_group_name       = local.rgname
  location                  = var.location
  account_tier              = "Premium"
  account_kind              = "FileStorage"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  allow_nested_items_to_be_public  = false
#   enable_https_traffic_only = false # required for NFS
  #  azure_files_authentication = {
  #      directory_type = "AADDS"
  #  }
    tags = {
      "Application" = "docgen"
    }
}
resource "azurerm_private_endpoint" "econexstreamnfs" {
  name                = "${var.prefix}exstreamnfs${var.environment}-endpoint"
  resource_group_name = local.rgname
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnetdocgenstorage.id

  private_service_connection {
    name                           = "${var.prefix}exstreamnfs${var.environment}-serviceconnection"
    private_connection_resource_id = azurerm_storage_account.econexstreamnfs.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storacctfileprivatelink.id]
  }
  tags = {
      "Application" = "docgen"
    }
}
resource "azurerm_storage_share" "econexstreamnfs" {
  name                 = "econexstreamnfs"
  storage_account_name = azurerm_storage_account.econexstreamnfs.name
  enabled_protocol     = "NFS"
  quota                = var.environment == "intp" ? 100 : (var.environment == "prod" ? 500 : 150)
}
# ------------------
# EXSTREAM SMB script/export storage
# ------------------
resource "azurerm_storage_account" "econexstreamsmb" {
  name                     = "${var.prefix}exstreamsmb${var.environment}"
  resource_group_name      = local.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = var.environment == "devm" ? false : true
  #  azure_files_authentication = {
  #      directory_type = "AADDS"
  #  }
    tags = {
      "Application" = "docgen"
    }
}
resource "azurerm_private_endpoint" "econexstreamsmb" {
  name                = "${var.prefix}exstreamsmb${var.environment}-endpoint"
  resource_group_name = local.rgname
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnetdocgenstorage.id

  private_service_connection {
    name                           = "${var.prefix}exstreamsmb${var.environment}-serviceconnection"
    private_connection_resource_id = azurerm_storage_account.econexstreamsmb.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storacctfileprivatelink.id]
  }
  tags    = {
         "Application" = "docgen"
        }
}
resource "azurerm_storage_share" "econexstreamsmb" {
  name                 = "exstreamhotfolder"
  storage_account_name = azurerm_storage_account.econexstreamsmb.name
  quota = var.environment == "prod" ? 5120 : 500   # size in GiB Mandatory to give
}
# ------------------
# EXSTREAM mail resource folder (public, web)
# ------------------
# used from the NON-PROD deployment (?)