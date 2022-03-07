variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "owner" {
  default     = "info@po4ta.me"
  description = "Owner of the resources."
}

variable "resource_group_name_prefix" {
  default     = "dev"
  description = "Prefix of the resource group name."
}

variable "github_token" {
  default     = "ghp_"
  description = "Personal access tokens."
}

variable "github_owner" {
  default     = "rzsvet"
  description = "Owner of the organization."
}

variable "github_branch" {
  default     = "master"
  description = "Branch of the code."
}
