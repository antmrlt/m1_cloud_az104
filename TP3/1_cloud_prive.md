## I. Présentation du lab

### 1. Architecture

| Node           | IP Address  | Rôle                         |
|----------------|-------------|------------------------------|
| `frontend.one` | `10.3.1.10` | WebUI OpenNebula             |
| `kvm1.one`     | `10.3.1.11` | Hyperviseur + Endpoint VXLAN |
| `kvm2.one`     | `10.3.1.12` | Hyperviseur + Endpoint VXLAN |

🌞 **Allumez les VMs et effectuez la conf élémentaire :**

```
[bingo@frontend ~]$ ping kvm1.one
PING kvm1.one (192.168.43.51) 56(84) bytes of data.
64 bytes from kvm1.one (192.168.43.51): icmp_seq=1 ttl=64 time=10.4 ms
64 bytes from kvm1.one (192.168.43.51): icmp_seq=2 ttl=64 time=30.1 ms
64 bytes from kvm1.one (192.168.43.51): icmp_seq=3 ttl=64 time=8.31 ms
^C
--- kvm1.one ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 8.310/16.260/30.083/9.811 ms
[bingo@frontend ~]$ ping kvm2.one
PING kvm2.one (192.168.43.52) 56(84) bytes of data.
64 bytes from kvm2.one (192.168.43.52): icmp_seq=1 ttl=64 time=9.97 ms
64 bytes from kvm2.one (192.168.43.52): icmp_seq=2 ttl=64 time=16.4 ms
64 bytes from kvm2.one (192.168.43.52): icmp_seq=3 ttl=64 time=9.80 ms
^C
--- kvm2.one ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 9.802/12.046/16.368/3.056 ms
[bingo@frontend ~]$
```

### 2. Noeud Frontend

???+ note

    Il n'y a rien à faire pour le moment, le setup réel commence en partie II.  
    Je vous explique un peu comment fonctionne le machin pour le moment !

Le noeud `frontend.one` expose une interface Web sexy (oupa?) qui permet de contrôler la plateforme.

C'est depuis là qu'on fera nos premiers pas pour :

- créer un réseau
- télécharger des templates de VMs
- ajouter des noeuds de virtu au cluster (nos noeuds KVM)
- et surtout, créer des VMs !

### 3. Noeuds KVM

Les noeuds `kvm1.one` et `kvm2.one` sont des VMs avec qemu/KVM installés, qui à deux, forment l'hyperviseur natif qu'on utilise sur des systèmes Linux.

???+ info

    On parle souvent juste de "hyperviseur KVM" bien que qemu soit systématiquement présent dans le mix.  
    KVM c'est la feature du kernel qui permet de gérer des environnements virtuels.  
    `qemu` est l'émulateur de processeur, qui occupe donc une place centrale dans un système de virtu.

Pour contrôler des VMs KVM, il faut utiliser le démon `libvirtd`. Une fois qu'il est démarré, on peut l'utiliser pour gérer des VMs.

???+ note

    On ne l'utilisera pas nous-mêmes dans ce TP le démon `libvirtd` : c'est OpenNebula qui s'en servira pour créer des VMs.

L'idée ici, dans le contexte du TP, c'est de préparer deux VMs avec l'hyperviseur KVM installé, et on permettra au noeud `frontend.one` de s'y connecter en SSH pour gérer des VMs.

???+ note

    Ui, OpenNebula repose sur OpenSSH entièrement pour la communication entre les diverses machines.  
    Simpliste, mais surtout standard, largement éprouvé, secure et robuste !

## II. Setup

### 1. Frontend

Le noeud `frontend.one` va héberger la logique de l'application, et exposer la WebUI ainsi que l'API.

➜ **J'ai fait [un doc dédié pour le setup du frontend](frontend.md), déroulez-le en entier sur la machine `frontend.one` avant de continuer.**

### 2. Noeuds KVM

Le noeud `kvm1.one` va héberger un hyperviseur KVM. Il sera contrôlé par `frontend.one` (à travers SSH).

➜ **J'ai fait [un doc dédié pour le setup des noeuds KVM](kvm.md), déroulez-le en entier, uniquement sur la machine `kvm1.one`, avant de continuer.**

???+ note

    On configurera `kvm2.one` plus tard !

### 3. Réseau

On va créer un réseau VXLAN pour que les VMs pourront utiliser pour communiquer.

???+ info

    VXLAN c'est une techno d'overlay networking. Cela permet d'avoir des réseaux virtuels par dessus un réseau physique.  
    Les switches et routeurs physiques de l'infra ne voient pas le trafic entre les VMs, ils voient seulement les hyperviseurs qui échangent beaucoup de trames.  
    VXLAN permet, si deux VMs s'échangent des messages, alors qu'elles sont physiquement réparties sur deux hyperviseurs différents, elles auront l'illusion d'être dans le même LAN physique (alors que potentiellement séparée par des milliers de km)

➜ **Pouif, là encore, j'ai fait [un doc dédié pour le setup du réseau](network.md), déroulez-le en entier, avant de continuer.**

- les commandes ne sont à effectuer que `kvm1.one`
- le setup de `kvm2.one` ne viendra que dans la partie IV du TP

## III. Utiliser la plateforme

Bah ouais il serait temps nan. Pop des ptites VMs.

OpenNebula fournit des images toutes prêtes, ready-to-use, qu'on peut lancer au sein de notre plateforme Cloud.

➜ **RDV de nouveau sur la WebUI de OpenNebula, et naviguez dans `Settings > Onglet Auth`**

- OpenNebula a généré une paire de clé sur la machine `frontend.one`
- elle se trouve dans le dossier `.ssh` dans le homedir de l'utilisateur `oneadmin`
- déposez la clé publique dans cet interface de la WebUI

???+ note

    *Dans un cas réel, on poserait clairement une autre clé, la nôtre.  
    On pourrait aussi en déposer plusieurs, s'il y a plusieurs admins dans la boîte. Ca pourrait se faire avec une image custom et du `cloud-init` par exemple.  
    Là on fait ça comme ça, pour pas vous brainfuck avec 14 clés différentes. Appelez-moi pour un setup propre si vous voulez.*

➜ **Toujours sur la WebUI de OpenNebula, naviguez dans `Storage > Apps`**

Récupérez l'image de Rocky Linux 9 dans cette interface.

???+ note

    Les images proposées par les gars d'OpenNebula, on peut s'y connecter qu'en SSH, il faudra donc pouvoir les joindre par le réseau pour les utiliser.

➜ **Toujouuuuurs sur la WebUI de OpenNebula, naviguez dans `Instances > VMs`**

- créez votre première VM :

    - doit utiliser l'image Rocky Linux 9 qu'on a créé précédemment
    - doit utiliser le virtual network créé précédemment

➜ **Tester la connectivité à la VM**

- déjà est-ce qu'on peut la ping ?

    - depuis le noeud `kvm1.one`, faites un `ping` vers l'IP de la VM
    - l'IP de la VM est visible dans la WebUI

- pour pouvoir se co en SSH, il faut utiliser la clé de `oneadmin`, suivez le guide :

```bash
# connectez vous en SSH sur la machine frontend.one

# devenez l'utilisateur oneadmin
[it4@frontend ~]$ sudo su - oneadmin

# lancez un agent SSH (demandez-moi si vous voulez une explication sur ça)
[oneadmin@frontend ~]$ eval $(ssh-agent)

# ajoutez la clé privée à l'agent SSH
[oneadmin@frontend ~]$ ssh-add
Identity added: /var/lib/one/.ssh/id_rsa (oneadmin@frontend)

# rebondir sur kvm1 pour se connecter à la VM qui a l'IP 10.220.220.100
[oneadmin@frontend ~]$ ssh -J kvm1 root@10.220.220.100

# on est co dans la VM
[root@localhost ~]# 
```

➜ **Si vous avez bien un shell dans la VM, vous êtes au bout des péripéties, pour un setup basique !**

- vous pouvez éventuellement ajouter l'IP de la machine hôte comme route par défaut pour avoir internet (l'IP du bridge VXLAN de l'hôte) :

```bash
[root@localhost ~]# ip route add default via 10.220.220.201
[root@localhost ~]# ping 1.1.1.1
```

## IV. Ajouter d'un noeud et VXLAN

➜ [**Et l'dernier ! Doc dédié à la partie IV.**](./kvm2.md)

![Someone else](./img/someone_else.png)
