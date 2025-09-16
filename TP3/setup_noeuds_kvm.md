# II.2. Noeuds KVM

![KVM bare-metal](./img/bare_kvm.png)

Dans un premier temps, **toute cette partie est à réaliser uniquement sur `kvm1.one`.**

Je vous recommande de faire ça sur un seul noeud d'abord, en entier, et une fois que ça fonctionne, vous ajouterez le deuxième (dans la partie IV. du TP).

## A. KVM

🌞 **Ajouter des dépôts supplémentaires**

- ajoutez les dépôts de OpenNebula, les mêmes que pour le Frontend !

`sudo nano /etc/yum.repos.d/opennebula.repo`

```
[opennebula]
name=OpenNebula Community Edition
baseurl=https://downloads.opennebula.io/repo/6.10/RedHat/$releasever/$basearch
enabled=1
gpgkey=https://downloads.opennebula.io/repo/repo2.key
gpgcheck=1
repo_gpgcheck=1
```

```sh
[antna@kvm1 ~]$ sudo dnf makecache -y
OpenNebula Community Edition                                                                                                                                                     1.5 kB/s | 833  B     00:00
OpenNebula Community Edition                                                                                                                                                      20 kB/s | 3.1 kB     00:00
Importing GPG key 0x906DC27C:
 Userid     : "OpenNebula Repository <contact@opennebula.io>"
 Fingerprint: 0B2D 385C 7C93 04B1 1A03 67B9 05A0 5927 906D C27C
 From       : https://downloads.opennebula.io/repo/repo2.key
OpenNebula Community Edition                                                                                                                                                     662 kB/s | 690 kB     00:01
Rocky Linux 9 - BaseOS                                                                                                                                                           4.8 kB/s | 4.1 kB     00:00
Rocky Linux 9 - AppStream                                                                                                                                                        4.2 kB/s | 4.5 kB     00:01
Rocky Linux 9 - Extras                                                                                                                                                           2.8 kB/s | 2.9 kB     00:01
Metadata cache created.
```

- ajoutez aussi les dépôts du serveur MySQL communautaire

```sh
[antna@kvm2 ~]$ wget https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm
--2025-09-15 11:20:38--  https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm
Resolving dev.mysql.com (dev.mysql.com)... 23.54.143.15, 2a02:26f0:680:48c::2e31, 2a02:26f0:680:48b::2e31
Connecting to dev.mysql.com (dev.mysql.com)|23.54.143.15|:443... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: https://repo.mysql.com//mysql80-community-release-el9-5.noarch.rpm [following]
--2025-09-15 11:20:39--  https://repo.mysql.com//mysql80-community-release-el9-5.noarch.rpm
Resolving repo.mysql.com (repo.mysql.com)... 184.85.187.76, 2a02:26f0:680:28d::1d68, 2a02:26f0:680:297::1d68
Connecting to repo.mysql.com (repo.mysql.com)|184.85.187.76|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 13319 (13K) [application/x-redhat-package-manager]
Saving to: ‘mysql80-community-release-el9-5.noarch.rpm’

mysql80-community-release-el9-5.noarch.rpm           100%[===================================================================================================================>]  13.01K  --.-KB/s    in 0s

2025-09-15 11:20:39 (212 MB/s) - ‘mysql80-community-release-el9-5.noarch.rpm’ saved [13319/13319]

[antna@kvm2 ~]$ sudo rpm -ivh mysql80-community-release-el9-5.noarch.rpm
warning: mysql80-community-release-el9-5.noarch.rpm: Header V4 RSA/SHA256 Signature, key ID 3a79bd29: NOKEY
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:mysql80-community-release-el9-5  ################################# [100%]
[antna@kvm2 ~]$ dnf repolist | grep mysql
mysql-connectors-community             MySQL Connectors Community
mysql-tools-community                  MySQL Tools Community
mysql80-community                      MySQL 8.0 Community Server
[antna@kvm2 ~]$
```

- ajoutez aussi les dépôts EPEL en exécutant :

```bash
sudo dnf install -y epel-release
```

🌞 **Installer les libs MySQL**

```bash
sudo dnf install -y mysql-community-server
```

🌞 **Installer KVM**

```bash
sudo dnf install -y opennebula-node-kvm
```

🌞 **Démarrer le service `libvirtd`**

```bash
sudo systemctl enable libvirtd
```

## B. Système

🌞 **Ouverture firewall**

| Port | Proto | Why ? |
|------|-------|-------|
| 22   | TCP   | SSH   |
| 8472 | UDP   | VXLAN |

```sh
[antna@kvm1 ~]$ sudo firewall-cmd --permanent --add-service=ssh
success
[antna@kvm1 ~]$ sudo firewall-cmd --add-port=8472/udp --permanent
success
[antna@kvm1 ~]$ sudo firewall-cmd --reload
success
```

🌞 **Handle SSH**

```sh
[oneadmin@frontend ~]$ ssh oneadmin@kvm1.one
Last login: Mon Sep 15 12:19:18 2025 from 192.168.43.50
[oneadmin@kvm1 ~]$
```

## C. Ajout des noeuds au cluster

➜ **RDV de nouveau sur la WebUI de OpenNebula, et naviguez dans `Infrastructure > Hosts`**

![init](/Images/kvm-init.png)

