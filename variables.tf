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