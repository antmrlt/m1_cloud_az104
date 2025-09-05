### A. Choix de l'algorithme de chiffrement

🌞 **Déterminer quel algorithme de chiffrement utiliser pour vos clés**

- **vous n'utiliserez PAS RSA**
- donner une source fiable qui explique pourquoi on évite RSA désormais (pour les connexions SSH notamment) : https://www.schneier.com/blog/archives/2023/11/new-ssh-vulnerability.html
- donner une source fiable qui recommande un autre algorithme de chiffrement (pour les connexions SSH notamment) : https://www.brandonchecketts.com/archives/ssh-ed25519-key-best-practices-for-2025

### B. Génération de votre paire de clés

🌞 **Générer une paire de clés pour ce TP**

- la clé privée doit s'appeler `cloud_tp1`
- elle doit se situer dans le dossier standard pour votre utilisateur
- elle doit utiliser l'algorithme que vous avez choisi à l'étape précédente (donc, pas de RSA)
- elle est protégée par un mot de passe de votre choix

```
$ ssh-keygen -t ed25519 -C "tpleo"
Generating public/private ed25519 key pair.
Enter file in which to save the key (C:\Users\antoi/.ssh/id_ed25519): cloud_tp1
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in cloud_tp1
Your public key has been saved in cloud_tp1.pub
The key fingerprint is:
SHA256:GGJ0**************************I tpleo
The key's randomart image is:
+--[ED25519 256]--+
|     ***   ***    |
|    ***** *****   |
|   *************  |
|   *************  |
|    ***********   |
|     *********    |
|      *******     |
|       *****      |
|        ***       |
+----[SHA256]-----+
```

### C. Agent SSH

🌞 **Configurer un agent SSH sur votre poste**

- détaillez-moi toute la conf ici que vous aurez fait

```
$ Start-Service ssh-agent
$ ssh-add C:\Users\antoi\.ssh\cloud_tp1
Enter passphrase for C:\Users\antoi\.ssh\cloud_tp1:
Identity added: C:\Users\antoi\.ssh\cloud_tp1 (tpleo)
```