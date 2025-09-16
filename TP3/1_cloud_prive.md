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

## II. Setup

### 1. Frontend

➜ **J'ai fait [un doc dédié pour le setup du frontend](./setup_frontend.md)..**

### 2. Noeuds KVM

➜ **J'ai fait [un doc dédié pour le setup des noeuds KVM](./setup_noeuds_kvm.md.md).**

### 3. Réseau

➜ **Pouif, là encore, j'ai fait [un doc dédié pour le setup du réseau](./setup_reseaux.md.md).**

## III. Utiliser la plateforme

➜ **Toujouuuuurs sur la WebUI de OpenNebula, naviguez dans `Instances > VMs`**

![vm](/Images/vm.png)

➜ **Tester la connectivité à la VM**

```bash
[oneadmin@frontend ~]$ eval $(ssh-agent)
Agent pid 5255
[oneadmin@frontend ~]$ ssh-add
Identity added: /var/lib/one/.ssh/id_rsa (oneadmin@frontend.one)
[oneadmin@frontend ~]$ ssh -J kvm1 root@192.168.69.69
Activate the web console with: systemctl enable --now cockpit.socket

[root@localhost ~]#
```

## IV. Ajouter d'un noeud et VXLAN

➜ [**Et l'dernier ! Doc dédié à la partie IV.**](./kvm2.md)

![Someone else](./img/someone_else.png)
