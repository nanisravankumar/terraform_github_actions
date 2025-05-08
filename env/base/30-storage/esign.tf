# only for DEVM
resource "azurerm_storage_account" "econesignsmb" {
  count = var.environment == "devm" ? 1 : 0
  name                     = "${var.prefix}esignsmb${lower(var.environment)}"
  resource_group_name      = local.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
#   public_network_access_enabled = false
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = true
}

resource "azurerm_private_endpoint" "econesignsmb" {
  count = var.environment == "devm" ? 1 : 0
  name                = "${var.prefix}esignsmb${lower(var.environment)}-endpoint"
  resource_group_name = local.rgname
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnetesignstorage.id
  private_service_connection {
    name                           = "${var.prefix}esignsmb${lower(var.environment)}-serviceconnection"
    private_connection_resource_id = azurerm_storage_account.econesignsmb[0].id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storacctfileprivatelink.id]
  }
}
resource "azurerm_storage_share" "econesignsmb" {
  count = var.environment == "devm" ? 1 : 0
  name                 = "econesignsmb"
  storage_account_name = azurerm_storage_account.econesignsmb[0].name
  quota = 5120
}

# Premium Storage account creation
resource "azurerm_storage_account" "econesignsmbprm" {
  name                     = "${var.prefix}esignsmb${lower(var.environment)}prm"
  resource_group_name      = local.rgname
  location                 = var.location
  account_kind             = "FileStorage"
  account_tier             = "Premium"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  public_network_access_enabled = "false"    //This attribute is unsupported in tf (1.1.7)version but required in upgraded version
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = true
  tags                      = var.tags
  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices",]
    ip_rules       = []
  }
  share_properties {
    retention_policy {
      days = 7
    }
    smb {
      authentication_types            = []
      channel_encryption_type         = []
      kerberos_ticket_encryption_type = []
      multichannel_enabled            = true
      versions                        = []
    }
  }
}

resource "azurerm_private_endpoint" "econesignsmbprm" {
  name                = "${var.prefix}esignsmbprm${lower(var.environment)}-endpoint"
  resource_group_name = local.rgname
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnetesignstorage.id
  private_service_connection {
    name                           = "${var.prefix}esignsmbprm${lower(var.environment)}-serviceconnection"
    private_connection_resource_id = azurerm_storage_account.econesignsmbprm.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storacctfileprivatelink.id]
  }
}

resource "azurerm_storage_share" "econesignfileshareprm" {
  name                 = "econesignsmb"
  storage_account_name = azurerm_storage_account.econesignsmbprm.name
  quota                = 100    # size in GiB Mandatory to give
}