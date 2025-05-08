# custom
resource "azurerm_private_dns_zone" "econcloud" {
  name                = "${var.environment}.${var.prefix}.local"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "econcloud" {
  name                  = "econcloud-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.econcloud.name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = true
}
# ACR
resource "azurerm_private_dns_zone" "acrprivatelink" {
  count               = var.hasACR ? 1 : 0

  name                = "privatelink.${var.environment}.${var.prefix}.azurecr.io"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "acrprivatelink" {
  count               = var.hasACR ? 1 : 0

  name                  = "acrprivatelink-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.acrprivatelink[0].name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = false
}
# AKV
resource "azurerm_private_dns_zone" "akvprivatelink" {
  name                = "privatelink.${var.environment}.${var.prefix}.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "akvprivatelink" {
  name                  = "akvprivatelink-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.akvprivatelink.name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = false
}
# Storage accounts
resource "azurerm_private_dns_zone" "storageblobprivatelink" {
  name                = "privatelink.${var.environment}.${var.prefix}.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "storageblobprivatelink" {
  name                  = "storageblobprivatelink-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.storageblobprivatelink.name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = false
}
resource "azurerm_private_dns_zone" "storagefileprivatelink" {
  name                = "privatelink.${var.environment}.${var.prefix}.file.core.windows.net"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "storagefileprivatelink" {
  name                  = "storagefileprivatelink-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.storagefileprivatelink.name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = false
}
# PostgreSQL
resource "azurerm_private_dns_zone" "pgsqlprivatelink" {
  name                = "privatelink.${var.environment}.${var.prefix}.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "pgsqlprivatelink" {
  name                  = "pgsqlprivatelink-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.pgsqlprivatelink.name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = false
}
# MSSQL
resource "azurerm_private_dns_zone" "mssqlprivatelink" {
  name                = "privatelink.${var.environment}.${var.prefix}.database.windows.net"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "mssqlprivatelink" {
  name                  = "mssqlprivatelink-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.mssqlprivatelink.name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = false
}
# Azure Monitor Private Link Scope
resource "azurerm_private_dns_zone" "amplsmonitorprivatelink" {
  name                = "privatelink.${var.environment}.${var.prefix}.monitor.azure.com"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "amplsmonitorprivatelink" {
  name                  = "amplsmonitorprivatelink-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.amplsmonitorprivatelink.name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = false
}
resource "azurerm_private_dns_zone" "amplsagentsvcprivatelink" {
  name                = "privatelink.${var.environment}.${var.prefix}.agentsvc.azure-automation.net"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "amplsagentsvcprivatelink" {
  name                  = "amplsagentsvcprivatelink-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.amplsagentsvcprivatelink.name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = false
}
resource "azurerm_private_dns_zone" "amplsodsprivatelink" {
  name                = "privatelink.${var.environment}.${var.prefix}.ods.opinsights.azure.com"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "amplsodsprivatelink" {
  name                  = "amplsodsprivatelink-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.amplsodsprivatelink.name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = false
}
resource "azurerm_private_dns_zone" "amplsomsprivatelink" {
  name                = "privatelink.${var.environment}.${var.prefix}.oms.opinsights.azure.com"
  resource_group_name = azurerm_resource_group.econcloud.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "amplsomsprivatelink" {
  name                  = "amplsomsprivatelink-dns-link"
  resource_group_name   = azurerm_resource_group.econcloud.name
  private_dns_zone_name = azurerm_private_dns_zone.amplsomsprivatelink.name
  virtual_network_id    = azurerm_virtual_network.econcloud.id
  registration_enabled  = false
}