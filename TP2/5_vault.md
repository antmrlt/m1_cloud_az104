*[Azure Key Vault]: Nom de la ressource Azure qui gère les secrets (la Vault de Azure quoi)
*[secret]: Un secret est un terme générique pour désigner toute donnée devant être manipulée avec beaucoup de sécurité : un password, un clé privée, un token, un ID, un etc.
*[secrets]: Un secret est un terme générique pour désigner toute donnée devant être manipulée avec beaucoup de sécurité : un password, un clé privée, un token, un ID, un etc.

# V. Azure Vault

## 1. Lil' intro ?

➜ Une *Vault* est un terme générique (démocratisé un peu par *[HashiCorp Vault](https://www.hashicorp.com/en/products/vault)*) pour un machin qui permet de stocker, gérer et récupérer des **secrets**.

C'est un cas plutôt récurrent désormais, avec l'ère du Cloud et des outils comme Terraform : **on écrit des *secrets* en clair un peu partout** si on fait rien de particulier.

**L'idée d'une *Vault* est donc de proposer un endroit centralisé et sécurisé où stocker ces *secrets*.**

On peut ensuite accéder à ces *secrets* après authentification (lecture/écriture). Souvent ça passe par le protocole HTTP (une API REST quoi) pour la plupart des *Vaults*.

➜ Azure propose une *Vault*, permettant de partager des *secrets* entre plusieurs VMs ou ressources. 

Et avec Terraform, on peut les définir à la volée de façon **aléatoire**, ou les **prédéfinir manuellement**.

???+ note

    On imagine facilement dans la vie réelle de passer sous forme de *secrets* stockés en Vault :  
      - des mots de passe de base de données (pour qu'un site accède à a sa DB)  
      - un token de monitoring (pour que la VM envoie ses datas)  
      - etc.

![Keep it safe](../../assets/img/meme_keep_it_secret.png)

## 2. Do it !

🌞 **Compléter votre plan Terraform et mettez en place une *Azure Key Vault***

- je vous recommande de créer un nouveau fichier `keyvault.tf` à côté de votre `main.tf`
- ce fichier foit :

    - ajouter [une ressource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) pour créer un *[Azure Key Vault](https://learn.microsoft.com/fr-fr/azure/key-vault/general/basic-concepts)*
    - définir ensuite un *secret* aléatoire avec Terraform

???+ note

    Encore une fois, en situation réelle, cette variable d'environnement pourrait ensuite être consommée par une application qui tourne sur la VM par exemple.  
    On peut aussi facilement imaginer un templating de fichiers à partir d'un *secret* récupéré dans la *Azure Key Vault*.

📁 **Fichiers attendus**

- `main.tf`
- `keyvault.tf`
- tout autre fichier Terraform utilisé

???+ tip

    Perso j'ai ajouté dans mon `output.tf` l'affichage du *secret*, pour vérifier que ça fonctionne bien pendant les tests.

## Help : Exemple de fichiers Terraform

- Il faut créer un *Azure Key Vault* et donner à votre VM les droits dessus

??? example

    ```tf
    resource "azurerm_key_vault" "meow_vault" {
      name                       = "<Le nom de ta Azure Key Vault ici>"
      location                   = azurerm_resource_group.main.location
      resource_group_name        = azurerm_resource_group.main.name
      tenant_id                  = data.azurerm_client_config.current.tenant_id
      sku_name                   = "standard"
      soft_delete_retention_days = 7
      purge_protection_enabled   = false
    
      access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id
        secret_permissions = [
          "Get", "List", "Set", "Delete", "Purge", "Recover"
        ]
      }
    
      access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = azurerm_linux_virtual_machine.main.identity[0].principal_id
        secret_permissions = [
          "Get", "List"
        ]
      }
    }
    ```

- Terraform peut générer des strings random, y'a une ressource dédiée à ça

??? example

    ```tf
    # 16 caractères, en remplaçant certains caractères qu'on veut pas
    resource "random_password" "meow_secret" {
      length           = 16
      special          = true
      override_special = "@#$%^&*()"
    }
    ```

- On peut ensuite récupérer la valeur dans une autre ressource

??? example

    ```tf
    # au hasard, pour créer un Secret dans une Azure Key Vault :)
    resource "azurerm_key_vault_secret" "meow_secret" {
      name         = "<Le nom de ton secret ici>"
      value        = random_password.meow_secret.result
      key_vault_id = azurerm_key_vault.meow_vault.id
    }
    ```

- **vous pouvez alors voir dans la WebUI Azure si vous voulez :**

    - dans `Key vaults` > `Le nom de ta Azure Key Vault` > `Secrets` > `Le nom de ton secret` > `Current version` > `Show Secret value`

## 3. Proof proof proof

🌞 **Avec une commande `az`, afficher le *secret***

- depuis votre poste, et votre compte Azure, vous avez les droits pour voir le *secret* normalement
- ça va se faire avec un `az keyvault secret show --name "<Le nom de ton secret ici>" --vault-name "<Le nom de ta Azure Key Vault ici>"`

🌞 **Depuis la VM, afficher le secret**

- il faut donc faire une requête à la Azure Key Vault depuis la VM Azure
- un ptit script shell ça le fait !

???+ note

    En situation réelle, ce serait l'application qui a besoin de ce *secret* qui effecturait la requête.  
    Si c'est pour templater un fichier de conf, on imagine facilement un Ansible, cloud-init, ou équivalent qui se charge de ça !

![GG EZ](../../assets/img/meme_gg_ez.png)
