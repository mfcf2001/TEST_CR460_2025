terraform {
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "remote" {
    organization = "CR460-POLY-2025"
 
    workspaces {
       name = "TEST_CR460_2025"
      }
    }
}


provider "azurerm" {
  features {}

  /*subscription_id = "ed3d6041-1bcc-4a73-9583-fc489a376bba"
  client_id       = "c44b4083-3bb0-49c1-b47d-974e53cbdf3c"
  # client_secret   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  tenant_id       = "a1728a60-1d50-4dcf-b851-ff698129a3e5"*/
}

#  Groupe de ressources
resource "azurerm_resource_group" "rg" {
  name     = "mon-groupe-ressources"
  location = "East US"
}

#  App Service Plan (hébergement)
resource "azurerm_service_plan" "app_service_plan" {
  name                = "myAppServicePlan"                 # Nom du Service Plan
  location            = azurerm_resource_group.rg.location # Récupère la localisation du Resource Group
  resource_group_name = azurerm_resource_group.rg.name     # Récupère le nom du Resource Group
  os_type             = "Linux" # Système d'exploitation (Linux ou Windows)
  sku_name            = "B1" # Tarif Basic
}

#  Web App (application)
resource "azurerm_linux_web_app" "web_app" {
  name                = "mywebapp1234" 
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }
}

#  Configuration du déploiement Git
resource "azurerm_app_service_source_control" "git_deploy" {
  app_id   = azurerm_linux_web_app.web_app.id
  repo_url = "https://github.com/mfcf2001/TEST_CR460_2025.git" # Remplacez par votre repo GitHub
  branch   = "main"
  use_manual_integration = true
}
