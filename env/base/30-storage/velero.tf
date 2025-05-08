# ------------------
# VELERO backup storage
# ------------------
resource "azurerm_storage_account" "storaccountbackup" {
  name                     = "${var.prefix}backup${var.environment}"
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
}
resource "azurerm_private_endpoint" "storaccountbackup" {
  name                = "${var.prefix}backup${var.environment}-endpoint"
  resource_group_name = local.rgname
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnetarchivestorage.id

  private_service_connection {
    name                           = "${var.prefix}backup${var.environment}-serviceconnection"
    private_connection_resource_id = azurerm_storage_account.storaccountbackup.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storageblobprivatelink.id]
  }
}
# ------------------
# VELERO backup container
# ------------------
resource "azurerm_storage_container" "velero" {
  name                  = "velero"
  storage_account_id    = azurerm_storage_account.storaccountbackup.id
  container_access_type = "private"
}