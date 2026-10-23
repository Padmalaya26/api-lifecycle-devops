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

resource "azurerm_service_plan" "appserviceplan" {

  name                = "asp-openweather"

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

  os_type             = "Linux"

  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "webapp" {

  name                = "openweather-api-padmalaya26"

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

  service_plan_id     = azurerm_service_plan.appserviceplan.id

  site_config {

    application_stack {
      node_version = "20-lts"
    }
  }
}