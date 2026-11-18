variable "ambiente" {
  description = "Nome do ambiente"
  type        = string
  default     = "dev"

  validation { # Impede valores inválidos
    condition     = contains(["dev", "prod"], var.ambiente)
    error_message = "O ambiente deve ser 'dev' ou 'prod'."
  }
}

variable "redis_senha" {
  description = "Senha do Redis"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.redis_senha) >= 8
    error_message = "A senha do Redis deve ter pelo menos 8 caracteres."
  }
}

variable "replicas" {
  description = "Quantidade de réplicas da aplicação"
  type        = number
  default     = 2

  validation {
    condition     = var.replicas >= 1 && var.replicas <= 5
    error_message = "O número de réplicas deve estar entre 1 e 5."
  }
}