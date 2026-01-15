# IMPORTANT: Add addon specific variables here
variable "gitlab_url" {
  type        = string
  default     = "https://gitlab.com/"
  description = "Gitlab URL"
  nullable    = false
}

variable "runner_registration_token" {
  type        = string
  default     = ""
  description = "The Registration Token for adding new Runners to the GitLab Server. This must be retrieved from your GitLab Instance"
  sensitive   = true
  nullable    = false
}
