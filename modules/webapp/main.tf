terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "app" {
  name = "contador-app:${var.ambiente}"

  build {
    context = var.caminho_app
  }

  # Reconstruir a imagem em caso de mudança
  triggers = {
    codigo = sha1(join("", [
      for arquivo in fileset(var.caminho_app, "*") :
      filesha1("${var.caminho_app}/${arquivo}")
    ]))
  }
}

resource "docker_container" "app" {
  count = var.replicas

  name    = "contador-app-${var.ambiente}-${count.index + 1}"
  image   = docker_image.app.image_id
  restart = "unless-stopped"

  env = [
    "REDIS_HOST=${var.redis_host}",
    "REDIS_PASSWORD=${var.redis_senha}",
    "AMBIENTE=${var.ambiente}",
    "NOME_REPLICA=app-${count.index + 1}",
  ]

  networks_advanced {
    name = var.rede_nome
  }
}

