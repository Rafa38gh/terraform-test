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

resource "docker_image" "redis" {
  name         = "redis:7.2-alpine"
  keep_locally = true
}

resource "docker_container" "redis" {
  name    = "contador-redis-${var.ambiente}"
  image   = docker_image.redis.image_id
  restart = "unless-stopped"

  command = [
    "redis-server",
    "--requirepass", var.redis_senha,
    "--appendonly", "yes"
  ]

  networks_advanced {
    name    = docker_network.rede.name
    aliases = ["redis"]
  }

  volumes {
    volume_name    = docker_volume.redis_dados.name
    container_path = "/data"
  }
}