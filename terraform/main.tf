# ──────────────────────────────────────────────────────────────────────────────
# main.tf — Azure infrastructure managed by Terraform
# ──────────────────────────────────────────────────────────────────────────────

# ── Common tags ───────────────────────────────────────────────────────────────

locals {
  tags = merge(
    {
      managed_by  = "terraform"
      environment = "tp"
      owner       = var.owner
    },
    var.tags
  )
}

# ── Resource Group ────────────────────────────────────────────────────────────

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = local.tags
}

# ── App Service Plan ──────────────────────────────────────────────────────────

resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  os_type  = "Linux"
  sku_name = "B1"

  tags = local.tags
}

# ── Storage ───────────────────────────────────────────────────────────────────

module "storage" {
  source = "./modules/storage"

  owner               = var.owner
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
}

# ── App Service ───────────────────────────────────────────────────────────────

module "app_service" {
  source = "./modules/app-service"

  owner               = var.owner
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id
  tags                = local.tags
}

# ── Function App ──────────────────────────────────────────────────────────────

module "function_app" {
  source = "./modules/function-app"

  owner               = var.owner
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id
  tags                = local.tags
}

# ── Container Instance ────────────────────────────────────────────────────────

module "container" {
  source = "./modules/container"

  owner               = var.owner
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
}

# ── Network ───────────────────────────────────────────────────────────────────

module "network" {
  source = "./modules/network"

  owner               = var.owner
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
}