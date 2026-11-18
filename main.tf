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

  lifecycle {
    precondition {
      condition = var.ambiente == terraform.workspace
      error_message = "O ambiente (${var.ambiente}) não corresponde ao workspace atual (${terraform.workspace})."
    }
  }
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

# Nginx
resource "docker_image" "nginx" {
  name         = "nginx:1.27-alpine"
  keep_locally = true
}

resource "docker_container" "nginx" {
  name    = "nginx-${var.ambiente}"
  image   = docker_image.nginx.image_id
  restart = "unless-stopped"

  ports {
    internal = 80
    external = var.porta
  }

  upload {
    file = "/etc/nginx/conf.d/default.conf"
    content = templatefile("${path.root}/nginx.conf.tftpl", {
      replicas = module.webapp.nomes_containers
    })
  }

  networks_advanced {
    name = docker_network.rede.name
  }
}

# Cria as réplicas da aplicação
module "webapp" {
  source = "./modules/webapp"

  ambiente    = var.ambiente
  replicas    = var.replicas
  rede_nome   = docker_network.rede.name
  redis_senha = var.redis_senha
  caminho_app = "${path.root}/app"

  depends_on = [docker_container.redis]
}