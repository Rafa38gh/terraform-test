variable "ambiente" {
  description = "Nome do ambiente"
  type        = string
}

variable "replicas" {
  description = "Número de réplicas da aplicação"
  type        = number
}

variable "rede_nome" {
  description = "Nome da rede Docker"
  type        = string
}

variable "redis_senha" {
  description = "Senha do Redis"
  type        = string
  sensitive   = true
}

variable "redis_host" {
  description = "Host do redis"
  type        = string
  default     = "redis"
}

variable "caminho_app" {
  description = "Caminho da aplicação"
  type        = string
}