### 1. Adapter le plan Terraform

🌞 Donner un nom DNS à votre VM

```sh
resource "azurerm_public_ip" "main" {
  name                = "vm-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  domain_name_label   = "karambarbar" # ICI
}
```

### 2. Ajouter un output custom à `terraform apply`

🌞 Un ptit output nan ?

-> [juste ici](../Terraform/outputs.tf)

## 3. Proooofs ! 

🌞 **Proofs ! Donnez moi :**

- la sortie du `terraform apply` (ce qu'affiche votre `outputs.tf`)

```shell
Outputs:

vm_public_dns = "karambarbar.francecentral.cloudapp.azure.com"
vm_public_ip = "**.**.**.**"
```

- une commande `ssh` fonctionnelle vers le nom de domaine (pas l'IP)

```shell
$ ssh -i C:\Users\antoi\.ssh\id_tpleo antnaTerraform@karambarbar.francecentral.cloudapp.azure.com
The authenticity of host 'karambarbar.francecentral.cloudapp.azure.com (4.212.9.7)' can't be established.
ED25519 key fingerprint is SHA256:de6X2yfmfcKVuXhQu6cfNGP0ggcmhB28Q1YZDdKgTXI.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'karambarbar.francecentral.cloudapp.azure.com' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

...

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

antnaTerraform@cliTerraform:~$
```

📁 **Fichiers attendus**

-> [juste ici](../Terraform)
