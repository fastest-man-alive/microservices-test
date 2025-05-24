variable "project" {
  type        = string
  description = "GCP project ID"
}

variable "account_id" {
  type        = string
  description = "The account ID (used to generate email)"
}

variable "display_name" {
  type        = string
  description = "Display name of the service account"
}

variable "project_roles" {
  type        = list(string)
  default     = []
  description = "List of project-level IAM roles to assign"
}
