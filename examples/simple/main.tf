locals {
  name    = "quarks-pocs"
  project = "quarks-pocs"
  region  = "us-east1"
}

provider "google" {
  project = local.project
  region  = local.region
}

module "database_instance" {
  source              = "../.."
  project             = local.project
  region              = local.region
  name                = local.name
  database_version    = "POSTGRES_14"
  deletion_protection = false

  private_network = {
    enabled      = false
  }

  databases = [{
    name = "quarks-pocs"
  }]
  users = [{
    name     = "quarks",
    password = "quarks@2057"
  }]
  settings = {
    disk_size = "20"
    tier      = "db-f1-micro"
    disk_type = "PD_SSD"

    ip_configuration = {
      ipv4_enabled = true
      authorized_networks = [{
        name  = "allow-all",
        range = "0.0.0.0/0"
      }]
    }

    data_cache_config = {
      data_cache_enabled = false
    }

    backup_configuration = {
      enabled            = false
      binary_log_enabled = false
    }

  }
}

