terraform {
  required_version = ">= 1.5.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "rede" {
  name = "contador-rede-${var.ambiente}"
}

resource "docker_volume" "redis_dados" {
  name = "contador-redis-${var.ambiente}"
}