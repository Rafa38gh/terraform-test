output "nomes_containers" {
  description = "Nomes dos containers das réplicas"
  value       = docker_container.app[*].name
}