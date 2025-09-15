## 2. Ajouter un NSG au déploiement

🌞 **[Ajouter un NSG à votre déploiement Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)**

```bash
variable "my_public_ip" {
  description = "Votre adresse IP publique pour autoriser SSH"
  type        = string
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-SSH-From-My-IP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
  }
}

# Attache le NSG à la NIC de ta VM
resource "azurerm_network_interface_security_group_association" "vm_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}
```

## 3. Proofs !

🌞 **Prouver que ça fonctionne, rendu attendu :**

- la sortie du `terraform apply` (ce qu'affiche votre `output.tf`)

```sh
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_linux_virtual_machine.main will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_username                                         = "antnaTerraform"
      + allow_extension_operations                             = (known after apply)
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disable_password_authentication                        = (known after apply)
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "francecentral"
      + max_bid_price                                          = -1
      + name                                                   = "cliTerraform"
      + network_interface_ids                                  = (known after apply)
      + os_managed_disk_id                                     = (known after apply)
      + patch_assessment_mode                                  = (known after apply)
      + patch_mode                                             = (known after apply)
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = (known after apply)
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "tp1leoTerraform"
      + size                                                   = "Standard_B1ls"
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = (known after apply)

      + admin_ssh_key {
          + public_key = <<-EOT
                ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+iIGe+eyXVoyRJcxWetFcKmUkkSTc19PLc0gFftdy4 tpleo
            EOT
          + username   = "antnaTerraform"
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + id                        = (known after apply)
          + name                      = "vm-os-disk"
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "0001-com-ubuntu-server-focal"
          + publisher = "Canonical"
          + sku       = "20_04-lts"
          + version   = "latest"
        }

      + termination_notification (known after apply)
    }

  # azurerm_network_interface.main will be created
  + resource "azurerm_network_interface" "main" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "francecentral"
      + mac_address                    = (known after apply)
      + name                           = "vm-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "tp1leoTerraform"
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + public_ip_address_id                               = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface_security_group_association.vm_nsg_assoc will be created
  + resource "azurerm_network_interface_security_group_association" "vm_nsg_assoc" {
      + id                        = (known after apply)
      + network_interface_id      = (known after apply)
      + network_security_group_id = (known after apply)
    }

  # azurerm_network_security_group.vm_nsg will be created
  + resource "azurerm_network_security_group" "vm_nsg" {
      + id                  = (known after apply)
      + location            = "francecentral"
      + name                = "vm-nsg"
      + resource_group_name = "tp1leoTerraform"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "22"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "Allow-SSH-From-My-IP"
              + priority                                   = 1001
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "104.28.243.189"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
        ]
    }

  # azurerm_public_ip.main will be created
  + resource "azurerm_public_ip" "main" {
      + allocation_method       = "Dynamic"
      + ddos_protection_mode    = "VirtualNetworkInherited"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "francecentral"
      + name                    = "vm-ip"
      + resource_group_name     = "tp1leoTerraform"
      + sku                     = "Basic"
      + sku_tier                = "Regional"
    }

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "francecentral"
      + name     = "tp1leoTerraform"
    }

  # azurerm_subnet.main will be created
  + resource "azurerm_subnet" "main" {
      + address_prefixes                              = [
          + "10.0.1.0/24",
        ]
      + default_outbound_access_enabled               = true
      + id                                            = (known after apply)
      + name                                          = "vm-subnet"
      + private_endpoint_network_policies             = "Disabled"
      + private_link_service_network_policies_enabled = true
      + resource_group_name                           = "tp1leoTerraform"
      + virtual_network_name                          = "vm-vnet"
    }

  # azurerm_virtual_network.main will be created
  + resource "azurerm_virtual_network" "main" {
      + address_space                  = [
          + "10.0.0.0/16",
        ]
      + dns_servers                    = (known after apply)
      + guid                           = (known after apply)
      + id                             = (known after apply)
      + location                       = "francecentral"
      + name                           = "vm-vnet"
      + private_endpoint_vnet_policies = "Disabled"
      + resource_group_name            = "tp1leoTerraform"
      + subnet                         = (known after apply)
    }

Plan: 8 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Still creating... [00m10s elapsed]
azurerm_resource_group.main: Still creating... [00m20s elapsed]
azurerm_resource_group.main: Creation complete after 22s [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform]
azurerm_virtual_network.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_network_security_group.vm_nsg: Creating...
azurerm_public_ip.main: Still creating... [00m10s elapsed]
azurerm_network_security_group.vm_nsg: Still creating... [00m10s elapsed]
azurerm_virtual_network.main: Still creating... [00m10s elapsed]
azurerm_public_ip.main: Creation complete after 15s [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_network_security_group.vm_nsg: Creation complete after 16s [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/networkSecurityGroups/vm-nsg]
azurerm_virtual_network.main: Still creating... [00m20s elapsed]
azurerm_virtual_network.main: Creation complete after 20s [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Creating...
azurerm_subnet.main: Still creating... [00m10s elapsed]
azurerm_subnet.main: Creation complete after 14s [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Creating...
azurerm_network_interface.main: Still creating... [00m10s elapsed]
azurerm_network_interface.main: Creation complete after 18s [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_network_interface_security_group_association.vm_nsg_assoc: Creating...
azurerm_linux_virtual_machine.main: Creating...
azurerm_network_interface_security_group_association.vm_nsg_assoc: Still creating... [00m10s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m10s elapsed]
azurerm_network_interface_security_group_association.vm_nsg_assoc: Creation complete after 18s [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/networkInterfaces/vm-nic|/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/networkSecurityGroups/vm-nsg]
azurerm_linux_virtual_machine.main: Still creating... [00m20s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m30s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m40s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m50s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [01m00s elapsed]
azurerm_linux_virtual_machine.main: Creation complete after 1m3s [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Compute/virtualMachines/cliTerraform]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
```

- une commande `az` pour obtenir toutes les infos liées à la VM

```shell
az network nic show --resource-group tp1leoTerraform --name vm-nic --query "networkSecurityGroup" -o json
{
  "id": "/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/networkSecurityGroups/vm-nsg",
  "resourceGroup": "tp1leoTerraform"
}
```

- une commande `ssh` fonctionnelle 

```shell
$ ssh -i C:\Users\antoi\.ssh\id_tpleo antnaTerraform@51.103.**.**
The authenticity of host '**.**.**.** (**.**.**.**)' can't be established.
ED25519 key fingerprint is SHA256:LPwEmlThBb2FXNm6IRAM+8A0RxEQyVjROiYNwPboHgI.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '**.**.**.**' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

...

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

antnaTerraform@cliTerraform:~$
``` 

- changement de port :

    - modifiez le port d'écoute du serveur OpenSSH sur la VM pour le port 2222/tcp

`sudo nano /etc/ssh/sshd_config`
```
Port 2222
```

prouvez que le serveur OpenSSH écoute sur ce nouveau port (avec une commande `ss` sur la VM)

```shell
antnaTerraform@cliTerraform:~$ sudo ss -tulnp | grep 2222
tcp     LISTEN   0        128              0.0.0.0:2222          0.0.0.0:*       users:(("sshd",pid=1718,fd=3))
tcp     LISTEN   0        128                 [::]:2222             [::]:*       users:(("sshd",pid=1718,fd=4))*
```

prouvez qu'une nouvelle connexion sur ce port 2222/tcp ne fonctionne pas à cause du *NSG*

```
$ ssh -i C:\Users\antoi\.ssh\id_tpleo -p 2222 antnaTerraform@**.**.**.**
ssh: connect to host **.**.**.** port 2222: Connection timed out
```


📁 **Fichiers attendus**

-> [dossier Terraform](../Terraform/)
