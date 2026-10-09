output "resource_group" {

  value = azurerm_resource_group.rg.name
}

output "apim_name" {

  value = azurerm_api_management.apim.name
}

output "gateway_url" {

  value = azurerm_api_management.apim.gateway_url
}