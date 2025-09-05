## 1. Depuis la WebUI

🌞 **Connectez-vous en SSH à la VM pour preuve**

- cette connexion ne doit demander aucun password : votre clé a été ajoutée à votre Agent SSH

<<<<<<< HEAD
```shell
=======
```
>>>>>>> cdc11f89c4d87c9198dd89e9c02f84be9ae34657
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

<<<<<<< HEAD
```shell
=======
```
>>>>>>> cdc11f89c4d87c9198dd89e9c02f84be9ae34657
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

<<<<<<< HEAD
```shell
$ ssh -i C:\Users\antoi\.ssh\cloud_tp1 antna@**.**.**.**
=======
```
ssh -i C:\Users\antoi\.ssh\cloud_tp1 antna@**.**.**.**
>>>>>>> cdc11f89c4d87c9198dd89e9c02f84be9ae34657
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

<<<<<<< HEAD
```shell
antna@cli1:~$ systemctl status walinuxagent.service
Warning: The unit file, source configuration file or drop-ins of walinuxagent.service changed on disk. Run 'systemctl d>
● walinuxagent.service - Azure Linux Agent
     Loaded: loaded (/lib/systemd/system/walinuxagent.service; enabled; vendor preset: enabled)
    Drop-In: /run/systemd/system.control/walinuxagent.service.d
             └─50-CPUAccounting.conf, 50-MemoryAccounting.conf
     Active: active (running) since Fri 2025-09-05 11:56:51 UTC; 6min ago
   Main PID: 727 (python3)
      Tasks: 7 (limit: 405)
     Memory: 42.0M
        CPU: 2.586s
     CGroup: /system.slice/walinuxagent.service
             ├─ 727 /usr/bin/python3 -u /usr/sbin/waagent -daemon
             └─1019 python3 -u bin/WALinuxAgent-2.14.0.1-py3.12.egg -run-exthandlers

Sep 05 11:57:02 cli1 python3[1019]:        0        0 ACCEPT     tcp  --  *      *       0.0.0.0/0            168.63.12>
Sep 05 11:57:02 cli1 python3[1019]:        0        0 ACCEPT     tcp  --  *      *       0.0.0.0/0            168.63.12>
Sep 05 11:57:02 cli1 python3[1019]:        0        0 DROP       tcp  --  *      *       0.0.0.0/0            168.63.12>
Sep 05 11:57:03 cli1 python3[1019]: 2025-09-05T11:57:03.848355Z INFO ExtHandler ExtHandler Looking for existing remote 
```

- **...du service `cloud-init.service`**

```shell
antna@cli1:~$ systemctl status cloud-init.service
● cloud-init.service - Cloud-init: Network Stage
     Loaded: loaded (/lib/systemd/system/cloud-init.service; enabled; vendor preset: enabled)
     Active: active (exited) since Fri 2025-09-05 11:56:51 UTC; 9min ago
   Main PID: 482 (code=exited, status=0/SUCCESS)
        CPU: 1.129s

Sep 05 11:56:50 cli1 cloud-init[486]: |   ...   +.=oB=Bo|
Sep 05 11:56:50 cli1 cloud-init[486]: |    . o .EB=*o+O*|
Sep 05 11:56:50 cli1 cloud-init[486]: |     + + oo+o ++o|
Sep 05 11:56:50 cli1 cloud-init[486]: |      + S    .   |
Sep 05 11:56:50 cli1 cloud-init[486]: |     . o         |
Sep 05 11:56:50 cli1 cloud-init[486]: |                 |
Sep 05 11:56:50 cli1 cloud-init[486]: |                 |
Sep 05 11:56:50 cli1 cloud-init[486]: |                 |
Sep 05 11:56:50 cli1 cloud-init[486]: +----[SHA256]-----+
Sep 05 11:56:51 cli1 systemd[1]: Finished Cloud-init: Network Stage.

```

## 3. Terraforming ~~planets~~ infrastructures


🌞 **Utilisez Terraform pour créer une VM dans Azure**

```shell
$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/azurerm...
- Installing hashicorp/azurerm v4.43.0...
- Installed hashicorp/azurerm v4.43.0 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

$ terraform apply
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Refreshing state... [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/networkInterfaces/vm-nic]

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
      + network_interface_ids                                  = [
          + "/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Network/networkInterfaces/vm-nic",
        ]
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

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_linux_virtual_machine.main: Creating...
azurerm_linux_virtual_machine.main: Still creating... [00m10s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m20s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m30s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m40s elapsed]
azurerm_linux_virtual_machine.main: Creation complete after 50s [id=/subscriptions/142f1e87-3a7c-42d5-8841-1ecff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Compute/virtualMachines/cliTerraform]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

📁 **Fichiers à rendre**

-> [dossier Terraform](../Terraform/)

🌞 **Prouvez avec une connexion SSH sur l'IP publique que la VM est up**

- toujours pas de password avec votre Agent SSH normalement 🐈

```shell
$ ssh -i C:\Users\antoi\.ssh\id_tpleo antnaTerraform@**.**.**.**
The authenticity of host '**.**.**.** (**.**.**.**)' can't be established.
ED25519 key fingerprint is SHA256:B6EdG8aF4NB2V/OHzeqMoOQCygkpwBsYS8Q3OnY5uIc.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '**.**.**.**' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

...

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

antnaTerraform@cliTerraform:~$
```