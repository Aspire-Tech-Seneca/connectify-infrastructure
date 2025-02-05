module "common" {
  source       = "../.common"
}

# Create a resource group
resource "azurerm_resource_group" "app_resource_group" {
  name     = local.resource_group
  location = var.region

  tags = merge(local.default_tags, {
    Name = local.resource_group
  })
}

# Create a storage account
resource "azurerm_storage_account" "app_storage_account" {
  name                     = local.storage_account
  resource_group_name      = azurerm_resource_group.app_resource_group.name
  location                 = azurerm_resource_group.app_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS" #Locally Redundant Storage
  account_kind             = "BlobStorage"

  tags = merge(local.default_tags, {
    Name = upper("${local.storage_account}")
  })
  depends_on = [azurerm_resource_group.app_resource_group]
}

# Create a storage container
resource "azurerm_storage_container" "tfstate_storage_container" {
  name                  = "atctfstatecontainer"
  storage_account_name  = azurerm_storage_account.app_storage_account.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.app_storage_account]
}