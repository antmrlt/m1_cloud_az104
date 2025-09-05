## 1. Depuis la WebUI

🌞 **Connectez-vous en SSH à la VM pour preuve**

- cette connexion ne doit demander aucun password : votre clé a été ajoutée à votre Agent SSH

```
ssh -i C:\Users\antoi\.ssh\cloud_tp1 azureuser@4.178.136.116
The authenticity of host '4.178.136.116 (4.178.136.116)' can't be established.
ED25519 key fingerprint is SHA256:eNa4cU5aWvRZjxtykb7CI6OusUDQ6B3JAvZElOT1Eb8.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '4.178.136.116' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

...

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

azureuser@cloudTP1:~$
```

## 2. `az` : a programmatic approach

🌞 **Créez une VM depuis le Azure CLI**

```
$ az group create --location francecentral --name tp1leo
{
  "id": "/subscriptions/142f1e87-3a7***********c6610/resourceGroups/tp1leo",
  "location": "francecentral",
  "managedBy": null,
  "name": "tp1leo",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}

$ az vm create -g tp1leo -n cli_1 --image Ubuntu2204 --admin-username antna --ssh-key-values C:\Users\antoi\.ssh\cloud_tp1.pub --size Standard_B1ls
The default value of '--size' will be changed to 'Standard_D2s_v5' from 'Standard_DS1_v2' in a future release.
Selecting "northeurope" may reduce your costs. The region you've selected may cost more for the same services. You can disable this message in the future with the command "az config set core.display_region_identified=false". Learn more at https://go.microsoft.com/fwlink/?linkid=222571

{
  "fqdns": "",
  "id": "/subscriptions/142f1e87-3a7c-42d***********6610/resourceGroups/tp1leo/providers/Microsoft.Compute/virtualMachines/cli_1",
  "location": "francecentral",
  "macAddress": "60-45-BD-6D-AF-18",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.4",
  "publicIpAddress": "**.**.**.**",
  "resourceGroup": "tp1leo"
}
```

🌞 **Assurez-vous que vous pouvez vous connecter à la VM en SSH sur son IP publique**

```
ssh -i C:\Users\antoi\.ssh\cloud_tp1 antna@**.**.**.**
The authenticity of host '**.**.**.** (**.**.**.**)' can't be established.
ED25519 key fingerprint is SHA256:bBbibCEUGVfn5UnbN2xjXAJ/REl5OQum2AxXannZCjg.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '**.**.**.**' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1031-azure x86_64)

...

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

antna@cli1:~$
```

🌞 **Une fois connecté, prouvez la présence...**

- **...du service `walinuxagent.service`**

???+ note

    Ce service est spécifique à Azure. Il permet à Azure d'interagir avec la VM.

- **...du service `cloud-init.service`**

???+ note

    `cloud-init` est un outil **très standard et répandu dans tous les environnements Cloud**.  
    Il permet d'effectuer de la configuration automatiquement **au premier lancement de la VM**.  
    C'est **lui qui a créé votre utilisateur et déposé votre clé pour se co en SSH !**  
    Vous pouvez vérifier qu'il s'est bien déroulé avec la commande `cloud-init status`

## 3. Terraforming ~~planets~~ infrastructures

**Une dernière section pour jouer avec Terraform,** on se contente là encore de simplement créer une VM Azure.

???+ tip

    Je vous donne en [section 4 juste en dessous](#4-exemple-dutilisation-azure-terraform) un exemple de setup pour les fichiers Terraform, setup que je vous recommande d'utiliser pour créer une VM dans Azure avec Terraform.  
    Un simple déploiement de une VM prend déjà pas mal de lignes : on déclare **toutes les ressources Azure explicitement**.

🌞 **Utilisez Terraform pour créer une VM dans Azure**

- j'veux la suite de commande `terraform` utilisée dans le compte-rendu

???+ note

    Vous pouvez couper un peu l'ouput de votre `terraform apply` pour le compte-rendu, il est immense :d

📁 **Fichiers à rendre**

- `main.tf`
- tout autre fichier utilisé par Terraform (je vous propose des fichiers de base plus bas)

🌞 **Prouvez avec une connexion SSH sur l'IP publique que la VM est up**

- toujours pas de password avec votre Agent SSH normalement 🐈

---

## 4. Exemple d'utilisation Azure + Terraform

Parce que jui pas ~~trop~~ un animal, j'vous file un bon pattern de fichiers Terraform qui fait le job.

**Créez un dossier dédié** et déposez ces 3 fichiers :

### A. Création de fichiers

#### ➜ `main.tf`

`main.tf` : fait le job, il crée une par une toutes les ressources Azure nécessaires pour une VM fonctionnelle

??? example

    ```tf
    # main.tf

    provider "azurerm" {
      features {}
      subscription_id = var.subscription_id
    }
    
    resource "azurerm_resource_group" "main" {
      name     = var.resource_group_name
      location = var.location
    }
    
    resource "azurerm_virtual_network" "main" {
      name                = "vm-vnet"
      address_space       = ["10.0.0.0/16"]
      location            = azurerm_resource_group.main.location
      resource_group_name = azurerm_resource_group.main.name
    }
    
    resource "azurerm_subnet" "main" {
      name                 = "vm-subnet"
      resource_group_name  = azurerm_resource_group.main.name
      virtual_network_name = azurerm_virtual_network.main.name
      address_prefixes     = ["10.0.1.0/24"]
    }
    
    resource "azurerm_network_interface" "main" {
      name                = "vm-nic"
      location            = azurerm_resource_group.main.location
      resource_group_name = azurerm_resource_group.main.name
    
      ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.main.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.main.id
      }
    }
    
    resource "azurerm_public_ip" "main" {
      name                = "vm-ip"
      location            = azurerm_resource_group.main.location
      resource_group_name = azurerm_resource_group.main.name
      allocation_method   = "Dynamic"
      sku                 = "Basic"
    }
    
    resource "azurerm_linux_virtual_machine" "main" {
      name                = "super-vm"
      resource_group_name = azurerm_resource_group.main.name
      location            = azurerm_resource_group.main.location
      size                = "Standard_B1s"
      admin_username      = var.admin_username
      network_interface_ids = [
        azurerm_network_interface.main.id,
      ]
    
      admin_ssh_key {
        username   = var.admin_username
        public_key = file(var.public_key_path)
      }
    
      os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
        name                 = "vm-os-disk"
      }
    
      source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts"
        version   = "latest"
      }
    }
    ```

???+ note 

    On est vraiment au strict minimum là, prenez le temps de regarder un peu chaque ressource, capter à quoi elle sert. En particulier le Resource Group.

#### ➜ `variables.tf`

`variables.tf` : déclare les variables que peuvent utiliser les fichiers `.tf` (**déclaration** de variables)

??? example

    ```tf
    # variables.tf
    
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
    ```

#### ➜ `terraform.tfvars`

`terraform.tfvars` : définissez des valeurs pour les variables ici (**affectation** de variables)

???+ info

    **Vous allez avoir besoin de votre Subscription ID** : l'identifiant unique de votre abonnement Azure for Students.  
    Vous pouvez le récupérer depuis la WebUI ou avec une commande `az account show --query id`.

??? example

    Fichier `terraform.tfvars`
    ```tf
    resource_group_name = "choisis un nom de resource group :)"
    admin_username = "met ton username là"
    public_key_path = "chemin vers ta clé publique ici"
    location = "uksouth"
    subscription_id = "met ton Subscription ID azure là"
    ```

???+ danger 

    **HA** et évitez de `git push` votre Subscription ID sur une plateforme publique.  
    Bon y'a pas trop trop de conséquences, et c'est le compte Azure de l'EFREI, mais sait-on jamais.  
    De plus, on prend juste pas une mauvaise habitude à push des secrets publiquement là 👿

### B. Commandes Terraform

**Une fois les 3 fichiers en place** (`main.tf`, `variables.tf`, `terraform.tfvars`), déplacez-vous dans le dossier, et utilisez des commandes `terraform` :

```bash
# On se déplace dans le dossier qui contient le main.tf et les autres fichiers
cd terraform/

# Initialisation de Terraform, utile une seule fois
# Ici, Terraform va récupérer le nécessaire pour déployer sur Azure spécifiquement
terraform init

# Si vous voulez voir ce qui serait fait avant de déployer, vous pouvez :
terraform plan

# Pour déployer votre "plan Terraform" (ce qui est défini dans le main.tf)
terraform apply

# Pour détruire tout ce qui a été déployé (recommandé de le faire régulièrement pour déployer depuis zéro)
terraform destroy
```

![Shutdown VMs](../../assets/img/meme_shutdown_vms.png)
s