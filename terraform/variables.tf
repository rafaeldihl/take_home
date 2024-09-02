variable "secrets" {
  description = "Secrets to be created."
  type = map(object({
    name        = string
    description = string
    value       = string
  }))
  default = {}
}
