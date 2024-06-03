variable "tags" {
  description = "Common tags"
  type        = map(string)
}

output "tags" {
  value = var.tags
}