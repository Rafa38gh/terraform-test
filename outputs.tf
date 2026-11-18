output "url" {
  description = "Endereço de acesso à aplicação"
  value       = "http://localhost:${var.porta}"
}

output "ambiente" {
  description = "Ambiente implantado"
  value       = var.ambiente
}

output "replicas" {
  description = "Nomes dos containers das réplicas"
  value       = module.webapp.nomes_containers
}

output "balanceador" {
  description = "Nome do container do Nginx"
  value       = docker_container.nginx.name
}

output "redis_senha" {
  description = "Senha do Redis"
  value       = var.redis_senha
  sensitive   = true
}