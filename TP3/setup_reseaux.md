# II.3. Setup réseau

## B. Création du Virtual Network

➜ **RDV de nouveau sur la WebUI de OpenNebula, et naviguez dans `Network > Virtual Networks`**

➜ **Créer un nouveau Virtual Network :**

![](/Images/reseau-init.png)

## C. Préparer le bridge réseau

➜ **Ces étapes sont à effectuer uniquement sur `kvm1.one`** dans un premier temps

- dans la partie IV du TP, quand vous mettrez en place `kvm2.one`, il faudra aussi refaire ça dessus

🌞 **Créer et configurer le bridge Linux**, j'vous file tout, suivez le guide :

```bash
[antna@kvm1 ~]$ sudo nano /usr/local/sbin/setup-vxlan-bridge.sh

#!/bin/bash

ip link add name vxlan_bridge type bridge
ip link set dev vxlan_bridge up
ip addr add 192.168.69.60/24 dev vxlan_bridge

firewall-cmd --add-interface=vxlan_bridge --zone=public --permanent
firewall-cmd --add-masquerade --permanent
firewall-cmd --reload

[antna@kvm1 ~]$ sudo chmod +x /usr/local/sbin/setup-vxlan-bridge.sh
```

```bash
[antna@kvm1 ~]$ sudo nano /etc/systemd/system/vxlan-bridge.service

[Unit]
Description=Setup VXLAN bridge
After=network.target firewalld.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/setup-vxlan-bridge.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

```bash
[antna@kvm1 ~]$ systemctl daemon-reload
[antna@kvm1 ~]$ systemctl enable vxlan-bridge.service
[antna@kvm1 ~]$ systemctl start vxlan-bridge.service
[antna@kvm1 ~]$ systemctl status vxlan-bridge.service
● vxlan-bridge.service - Setup VXLAN bridge
     Loaded: loaded (/etc/systemd/system/vxlan-bridge.service; enabled; preset: disabled)
     Active: active (exited) since Mon 2025-09-15 13:41:11 CEST; 3s ago
    Process: 13545 ExecStart=/usr/local/sbin/setup-vxlan-bridge.sh (code=exited, status=0/SUCCESS)
   Main PID: 13545 (code=exited, status=0/SUCCESS)
        CPU: 484ms

Sep 15 13:41:10 kvm1.one systemd[1]: Starting Setup VXLAN bridge...
Sep 15 13:41:10 kvm1.one setup-vxlan-bridge.sh[13546]: RTNETLINK answers: File exists
Sep 15 13:41:10 kvm1.one setup-vxlan-bridge.sh[13548]: Error: ipv4: Address already assigned.
Sep 15 13:41:10 kvm1.one setup-vxlan-bridge.sh[13549]: Warning: ALREADY_ENABLED: vxlan_bridge
Sep 15 13:41:10 kvm1.one setup-vxlan-bridge.sh[13549]: success
Sep 15 13:41:11 kvm1.one setup-vxlan-bridge.sh[13553]: Warning: ALREADY_ENABLED: masquerade
Sep 15 13:41:11 kvm1.one setup-vxlan-bridge.sh[13553]: success
```