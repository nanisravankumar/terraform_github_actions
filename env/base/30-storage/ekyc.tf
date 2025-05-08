# #--------------------Ekyc Pre-prod common Storage Account--------------------#
resource "azurerm_storage_account" "ekycstoragepreprod" {
  count = contains(["dev", "intp", "intm"], var.environment) ? 1 : 0
  name                          = "${var.prefix}ekycstoragepreprod"
  resource_group_name           = local.rgname_eternal
  location                      = var.location
  account_tier                  = "Standard"
  account_kind                  = "StorageV2"
  account_replication_type      = "LRS"
  public_network_access_enabled = true
  min_tls_version               = "TLS1_2"
  allow_nested_items_to_be_public  = false
  blob_properties {
    container_delete_retention_policy {
      days = 7
    }
  }
  access_tier                   = "Hot"
  tags                      = var.tags
  
  static_website {
    index_document     = null
    error_404_document = null
  }
}

# resource "azurerm_storage_container" "ekycsacontainer" {
#   count = var.environment == "prod" ? 0 : 1
#   name                  = "$web"
#   storage_account_name  = "${var.prefix}ekycstorage${lower(var.environment)}"
#   container_access_type = "private"
#   depends_on = [ azurerm_storage_account.ekycstorage ]
# }

# resource "azurerm_private_endpoint" "ekycstorage-pe" {
#   name                = "${var.prefix}ekycstorage${lower(var.environment)}-endpoint"
#   resource_group_name = local.rgname
#   location            = var.location
#   subnet_id           = data.azurerm_subnet.subnetekycsa.id

#   private_service_connection {
#     name                           = "${var.prefix}ekycstorage${lower(var.environment)}-serviceconnection"
#     private_connection_resource_id = azurerm_storage_account.ekycstorage.id
#     is_manual_connection           = false
#     subresource_names              = ["blob"]
#   }
#   private_dns_zone_group {
#     name                 = "default"
#     private_dns_zone_ids = [data.azurerm_private_dns_zone.storageblobprivatelink.id]
#   }
# }