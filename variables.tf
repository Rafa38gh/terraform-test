variable "ambiente" {
  description = "Nome do ambiente"
  type        = string
  default     = "dev"

  validation { # Impede valores inválidos
    condition     = contains(["dev", "prod"], var.ambiente)
    error_message = "O ambiente deve ser 'dev' ou 'prod'."
  }
}