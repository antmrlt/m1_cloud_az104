# IV. Ajout d'un noeud et VXLAN

Dernière partie : on configure `kvm2.one` et on teste les fonctionnalités réseau VXLAN : deux VMs sur des hyperviseurs différents se `ping` comme si elles étaient dans le même LAN !

## 1. Ajout d'un noeud

🌞 **Setup de `kvm2.one`, à l'identique de `kvm1.one`** excepté :

![](/Images/kvm-init.png)

## 2. VM sur le deuxième noeud

🌞 **Lancer une deuxième VM**

![](/Images/vm2.png)

```bash
[oneadmin@frontend ~]$ ssh -J kvm2 root@192.168.69.70
Warning: Permanently added '192.168.69.70' (ED25519) to the list of known hosts.
Activate the web console with: systemctl enable --now cockpit.socket

[root@localhost ~]#
```

## 3. Connectivité entre les VMs

🌞 **Les deux VMs doivent pouvoir se ping**

```bash
[root@localhost ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:00:c0:a8:45:46 brd ff:ff:ff:ff:ff:ff
    altname enp0s3
    altname ens3
    inet 192.168.69.70/24 brd 192.168.69.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::c0ff:fea8:4546/64 scope link
       valid_lft forever preferred_lft forever
[root@localhost ~]# ping 192.168.69.69
PING 192.168.69.69 (192.168.69.69) 56(84) bytes of data.
64 bytes from 192.168.69.69: icmp_seq=1 ttl=64 time=1.07 ms
64 bytes from 192.168.69.69: icmp_seq=2 ttl=64 time=1.44 ms
```

## 4. Inspection du trafic

🌞 **Téléchargez `tcpdump` sur l'un des noeuds KVM**

➜ [pcap enp0s8](/enp0s8.pcap)  
➜ [pcap vxlan](/vxlan.pcap)
