
locals {
  rgname         = "${var.prefix}cloud-resources-${var.environment}"
  vnetname       = "eConCloud-network-${var.environment}"
}

# ------------------
# OCR StorageAccount
# ------------------
resource "azurerm_storage_account" "ocrstorage" {
  count = contains(["prod", "intm", "apacintm"], var.environment) ? 1 : 0
  name                      = "${var.prefix}ocrstorage${lower(var.environment)}"
  resource_group_name       = local.rgname
  location                  = var.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "RAGRS"
  min_tls_version           = "TLS1_2"
  access_tier               = "Hot"
  tags                      = var.tags

share_properties {
 retention_policy {
    days    = 7
  }
}
}

resource "azurerm_storage_share" "ocrstorage" {
  count = contains(["prod", "intm", "apacintm"], var.environment) ? 1 : 0
  name                 = "${var.prefix}ocrstoragefileshare${lower(var.environment)}"
  storage_account_name = "${var.prefix}ocrstorage${lower(var.environment)}"
  enabled_protocol     = "SMB"
#   access_tier          = "TransactionOptimized"
  quota                = 5120
}
