variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  default     = "East US"
  description = "Azure region"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
}

variable "public_key_path" {
  type        = string
  description = "Path to your SSH public key"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "storage_account_name" {
  description = "Nom du compte de stockage (unique globalement)"
}
variable "storage_container_name" {
  description = "Nom du container dans le Blob Storage"
}

variable "alert_email_address" {
  description = "Email pour recevoir les alertes CPU"
  type        = string
}
