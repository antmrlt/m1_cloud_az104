output "vm_public_ip" {
  description = "Adresse IP publique de la VM"
  value       = azurerm_public_ip.main.ip_address
}

output "vm_public_dns" {
  description = "Nom DNS complet de la VM"
  value       = azurerm_public_ip.main.fqdn
}
