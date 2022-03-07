terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

output "hostname" {
  value = "https://${azurerm_static_site.dev.default_host_name}/"
}

locals {
  common_tags = {
    Owner = "${var.owner}"
  }
  resource_group_name = "${var.resource_group_name_prefix}-resource-group"
}

resource "azurerm_resource_group" "dev" {
  name     = "${var.resource_group_name_prefix}-resource-group-web-app"
  location = var.resource_group_location

  tags = merge(local.common_tags)
}

resource "azurerm_static_site" "dev" {
  name                = "${var.resource_group_name_prefix}-static-web-app"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name

  tags = merge(local.common_tags)
}

locals {
  api_token_var = "AZURE_STATIC_WEB_APPS_API_TOKEN"
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "github_actions_secret" "dev" {
  repository      = "2048" #Fork https://github.com/ukolovka/2048
  secret_name     = local.api_token_var
  plaintext_value = azurerm_static_site.dev.api_key
}

resource "github_repository_file" "dev" {
  repository = "2048"
  branch     = var.github_branch
  file       = ".github/workflows/azure-static-web-app.yml"
  content = templatefile("./azure-static-web-app.tpl",
    {
      app_location    = "/"
      api_location    = ""
      output_location = ""
      api_token_var   = local.api_token_var
      branch          = var.github_branch
    }
  )
  commit_message      = "Add workflow (by Terraform)"
  commit_author       = "aleksey"
  commit_email        = "info@po4ta.me"
  overwrite_on_create = true
}
