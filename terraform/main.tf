resource "azurerm_resource_group" "rg" {

  name     = var.resource_group_name

  location = var.location
}

resource "azurerm_api_management" "apim" {

  name                = "openweather-apim-devops"

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

  publisher_name      = "KTH DevOps Course"

  publisher_email     = "moharana@kth.se"

  sku_name            = "Developer_1"
}