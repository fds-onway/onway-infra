variable "name" {
  type        = string
  description = "O nome do usuário"
}

variable "policy_name" {
  type        = string
  description = "O nome que a policy deste usuário terá"
  default     = null
}

variable "policy" {
  type        = string
  description = "O JSON da Policy que o usuário terá"
}

variable "generate_access_key" {
  type        = bool
  description = "Se o usuário terá chave de acesso ou não"
  default     = false
}
