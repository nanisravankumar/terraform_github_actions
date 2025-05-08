# ------------------
# OTAC archive storage
# ------------------
resource "azurerm_storage_account" "storaccountotac" {
  name                     = "${var.prefix}archivestorage${var.environment}"
  resource_group_name      = local.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
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
    tags = {
      "Application" = "archive"
    }
}
resource "azurerm_private_endpoint" "storaccountotac" {
  name                = "${var.prefix}archivestorage${var.environment}-endpoint"
  resource_group_name = local.rgname
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnetarchivestorage.id

  private_service_connection {
    name                           = "${var.prefix}archivestorage${var.environment}-serviceconnection"
    private_connection_resource_id = azurerm_storage_account.storaccountotac.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storageblobprivatelink.id]
  }
  tags = {
     "Application" = "archive"
    }
}
# ------------------
# OTCS buffer & index storage
# ------------------
resource "azurerm_storage_account" "storaccountotcs" {
  name                     = "${var.prefix}otcsstorage${var.environment}"
  resource_group_name      = local.rgname
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
    tags = {
      "Application" = "archive"
    }
}
resource "azurerm_private_endpoint" "storaccountotcs" {
  name                = "${var.prefix}otcsstorage${var.environment}-endpoint"
  resource_group_name = local.rgname
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnetarchivestorage.id

  private_service_connection {
    name                           = "${var.prefix}otcsstorage${var.environment}-serviceconnection"
    private_connection_resource_id = azurerm_storage_account.storaccountotcs.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storageblobprivatelink.id]
  }
   tags = {
      "Application" = "archive"
    }

}