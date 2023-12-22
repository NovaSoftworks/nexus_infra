terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.2"
    }
  }
  cloud {
    organization = "NovaSoftworks"
    workspaces {
      name = "infrastructure-dev"
    }
  }
}

provider "azurerm" {
  features {}
}

module "network" {
  source = "../../modules/network"

  environment  = var.environment
  region       = var.region
  region_short = var.region_short
}

module "jumpbox" {
  source = "../../modules/jumpbox"

  environment  = var.environment
  region       = var.region
  region_short = var.region_short

  jumpbox_sku      = var.default_sku
  jumpbox_username = var.jumpbox_username
  jumpbox_password = var.jumpbox_password

  jumpbox_subnet_id = module.network.jumpbox_subnet_id
}

module "postgres" {
  source     = "../../modules/postgres"
  depends_on = [module.network]

  environment  = var.environment
  region       = var.region
  region_short = var.region_short

  postgres_sku      = var.default_sku
  postgres_username = var.postgres_username
  postgres_password = var.postgres_password

  postgres_dns_id    = module.network.postgres_dns_id
  postgres_subnet_id = module.network.postgres_subnet_id
}

module "redis" {
  source     = "../../modules/redis"
  depends_on = [module.network]

  environment  = var.environment
  region       = var.region
  region_short = var.region_short
}
