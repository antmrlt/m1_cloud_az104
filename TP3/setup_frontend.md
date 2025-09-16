# II.1. Setup Frontend


## A. Database

🌞 **Installer un serveur MySQL**

```
[bingo@frontend tmp]$ wget https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm
--2025-09-15 11:12:39--  https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm
Resolving dev.mysql.com (dev.mysql.com)... 104.85.37.194, 2a02:26f0:2b80:f95::2e31, 2a02:26f0:2b80:f8d::2e31
Connecting to dev.mysql.com (dev.mysql.com)|104.85.37.194|:443... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: https://repo.mysql.com//mysql80-community-release-el9-5.noarch.rpm [following]
--2025-09-15 11:12:39--  https://repo.mysql.com//mysql80-community-release-el9-5.noarch.rpm
Resolving repo.mysql.com (repo.mysql.com)... 104.85.20.87, 2a02:26f0:2b80:e8b::1d68, 2a02:26f0:2b80:e84::1d68
Connecting to repo.mysql.com (repo.mysql.com)|104.85.20.87|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 13319 (13K) [application/x-redhat-package-manager]
Saving to: ‘mysql80-community-release-el9-5.noarch.rpm’

mysql80-community-release-el9 100%[=================================================>]  13.01K  --.-KB/s    in 0s

2025-09-15 11:12:39 (35.1 MB/s) - ‘mysql80-community-release-el9-5.noarch.rpm’ saved [13319/13319]

[bingo@frontend tmp]$ sudo rpm -ivh mysql80-community-release-el9-5.noarch.rpm
warning: mysql80-community-release-el9-5.noarch.rpm: Header V4 RSA/SHA256 Signature, key ID 3a79bd29: NOKEY
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:mysql80-community-release-el9-5  ################################# [100%]
```
```
[bingo@frontend tmp]$ sudo dnf install -y mysql-community-server
MySQL 8.0 Community Server                                                              1.6 MB/s | 2.7 MB     00:01
MySQL Connectors Community                                                              246 kB/s |  90 kB     00:00
MySQL Tools Community                                                                   945 kB/s | 1.2 MB     00:01
```


🌞 **Démarrer le serveur MySQL**

```
[bingo@frontend tmp]$ systemctl status mysqld
● mysqld.service - MySQL Server
     Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; preset: disabled)
     Active: active (running) since Mon 2025-09-15 11:23:02 CEST; 58s ago
       Docs: man:mysqld(8)
             http://dev.mysql.com/doc/refman/en/using-systemd.html
   Main PID: 53841 (mysqld)
     Status: "Server is operational"
      Tasks: 38 (limit: 17532)
     Memory: 450.4M
        CPU: 8.325s
     CGroup: /system.slice/mysqld.service
             └─53841 /usr/sbin/mysqld

Sep 15 11:22:37 frontend.one systemd[1]: Starting MySQL Server...
Sep 15 11:23:02 frontend.one systemd[1]: Started MySQL Server.
```


🌞 **Setup MySQL**
```
[bingo@frontend tmp]$ sudo grep 'temporary password' /var/log/mysqld.log
2025-09-15T09:22:47.329138Z 6 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: ********
```

```
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY '********';
Query OK, 0 rows affected (0.02 sec)

mysql> CREATE USER 'oneadmin' IDENTIFIED BY '********';
Query OK, 0 rows affected (0.03 sec)

mysql> CREATE DATABASE opennebula;
Query OK, 1 row affected (0.04 sec)

mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin';
Query OK, 0 rows affected (0.02 sec)

mysql> SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
Query OK, 0 rows affected (0.01 sec)

mysql>
```


## B. OpenNebula

🌞 **Ajouter les dépôts Open Nebula**

```
[bingo@frontend /]$ sudo tee /etc/yum.repos.d/opennebula.repo > /dev/null << 'EOF'
> [opennebula]
> name=OpenNebula Community Edition
> baseurl=https://downloads.opennebula.io/repo/6.10/RedHat/$releasever/$basearch
> enabled=1
> gpgkey=https://downloads.opennebula.io/repo/repo2.key
> gpgcheck=1
> repo_gpgcheck=1
> EOF
```

🌞 **Installer OpenNebula**

```
[bingo@frontend /]$ sudo dnf makecache -y
Extra Packages for Enterprise Linux 9 - x86_64                                               3.1 MB/s |  20 MB     00:06
Extra Packages for Enterprise Linux 9 openh264 (From Cisco) - x86_64                         2.2 kB/s | 2.5 kB     00:01
MySQL 8.0 Community Server                                                                    33 kB/s | 3.0 kB     00:00
MySQL Connectors Community                                                                    33 kB/s | 3.0 kB     00:00
MySQL Tools Community                                                                         37 kB/s | 3.0 kB     00:00
OpenNebula Community Edition                                                                 1.9 kB/s | 833  B     00:00
Rocky Linux 9 - BaseOS                                                                        12 kB/s | 4.1 kB     00:00
Rocky Linux 9 - AppStream                                                                     11 kB/s | 4.5 kB     00:00
Rocky Linux 9 - Extras                                                                       6.9 kB/s | 2.9 kB     00:00
Metadata cache created.
[bingo@frontend /]$ sudo dnf install -y opennebula opennebula-sunstone opennebula-fireedge
```

🌞 **Configuration OpenNebula**

```
DB = [ BACKEND = "mysql",
       SERVER  = "localhost",
       PORT    = 0,
       USER    = "oneadmin",
       PASSWD  = "*******",
       DB_NAME = "opennebula",
       CONNECTIONS = 25,
       COMPARE_BINARY = "no" ]
```

🌞 **Créer un user pour se log sur la WebUI OpenNebula**

```
[bingo@frontend /]$ sudo su - oneadmin
Last login: Mon Sep 15 11:44:00 CEST 2025
[oneadmin@frontend ~]$ echo "bingoo:******" > ~/.one/one_auth
```

🌞 **Démarrer les services OpenNebula**

```
[bingo@frontend /]$ systemctl status opennebula
● opennebula.service - OpenNebula Cloud Controller Daemon
     Loaded: loaded (/usr/lib/systemd/system/opennebula.service; enabled; preset: disabled)
     Active: active (running) since Mon 2025-09-15 11:54:45 CEST; 12s ago
   Main PID: 58565 (oned)
      Tasks: 91 (limit: 17532)
     Memory: 359.9M
        CPU: 5.565s
     CGroup: /system.slice/opennebula.service
             ├─58565 /usr/bin/oned -f
             ├─58600 /usr/bin/ruby /usr/lib/one/mads/one_hm.rb -p 2101 -l 2102 -b 127.0.0.1
             ├─58624 /usr/bin/ruby /usr/lib/one/mads/one_vmm_exec.rb -t 15 -r 0 kvm -p
             ├─58641 /usr/bin/ruby /usr/lib/one/mads/one_vmm_exec.rb -t 15 -r 0 lxc
             ├─58658 /usr/bin/ruby /usr/lib/one/mads/one_vmm_exec.rb -t 15 -r 0 kvm
             ├─58677 /usr/bin/ruby /usr/lib/one/mads/one_tm.rb -t 15 -d dummy,lvm,shared,fs_lvm,fs_lvm_ssh,qcow2,ssh,ceph,de>
             ├─58700 /usr/bin/ruby /usr/lib/one/mads/one_auth_mad.rb --authn ssh,x509,ldap,server_cipher,server_x509
             ├─58715 /usr/bin/ruby /usr/lib/one/mads/one_datastore.rb -t 15 -d dummy,fs,lvm,ceph,dev,iscsi_libvirt,vcenter,r>
             ├─58732 /usr/bin/ruby /usr/lib/one/mads/one_market.rb -t 15 -m http,s3,one,linuxcontainers
             ├─58749 /usr/bin/ruby /usr/lib/one/mads/one_ipam.rb -t 1 -i dummy,aws,equinix,vultr
             ├─58763 /usr/lib/one/mads/onemonitord "-c monitord.conf"
             ├─58780 /usr/bin/ruby /usr/lib/one/mads/one_im_exec.rb -r 3 -t 15 -w 90 kvm
             ├─58793 /usr/bin/ruby /usr/lib/one/mads/one_im_exec.rb -r 3 -t 15 -w 90 lxc
             ├─58806 /usr/bin/ruby /usr/lib/one/mads/one_im_exec.rb -r 3 -t 15 -w 90 qemu
             └─58918 ruby /var/lib/one/remotes/market/one/monitor PE1BUktFVF9EUklWRVJfQUNUSU9OX0RBVEE+PE1BUktFVFBMQUNFPjxJRD>

Sep 15 11:54:27 frontend.one systemd[1]: Starting OpenNebula Cloud Controller Daemon...
Sep 15 11:54:27 frontend.one opennebula[58557]: error: error creating stub state file /var/lib/one/.logrotate.status: Permis>
Sep 15 11:54:27 frontend.one opennebula[58559]: gzip: /var/log/one/oned*.log: No such file or directory
Sep 15 11:54:27 frontend.one opennebula[58561]: gzip: /var/log/one/monitor*.log: No such file or directory
Sep 15 11:54:27 frontend.one opennebula[58563]: gzip: /var/log/one/vcenter_monitor*.log: No such file or directory
Sep 15 11:54:45 frontend.one systemd[1]: Started OpenNebula Cloud Controller Daemon.
lines 1-30/30 (END)
^C
[bingo@frontend /]$ systemctl status opennebula-sunstone
● opennebula-sunstone.service - OpenNebula Web UI Server
     Loaded: loaded (/usr/lib/systemd/system/opennebula-sunstone.service; enabled; preset: disabled)
     Active: active (running) since Mon 2025-09-15 11:54:52 CEST; 16s ago
    Process: 58882 ExecStartPre=/usr/sbin/logrotate -f /etc/logrotate.d/opennebula-sunstone -s /var/lib/one/.logrotate.statu>
    Process: 58886 ExecStartPre=/bin/sh -c for file in /var/log/one/sunstone*.log; do if [ ! -f "$file.gz" ]; then gzip -9 ">
   Main PID: 58888 (ruby)
      Tasks: 1 (limit: 17532)
     Memory: 102.6M
        CPU: 4.730s
     CGroup: /system.slice/opennebula-sunstone.service
             └─58888 /usr/bin/ruby /usr/lib/one/sunstone/sunstone-server.rb

Sep 15 11:55:02 frontend.one opennebula-sunstone[58888]:  :threshold_high=>66,
Sep 15 11:55:02 frontend.one opennebula-sunstone[58888]:  :support_fs=>["ext4", "ext3", "ext2", "xfs"],
Sep 15 11:55:02 frontend.one opennebula-sunstone[58888]:  :oneflow_server=>"http://localhost:2474/",
Sep 15 11:55:02 frontend.one opennebula-sunstone[58888]:  :routes=>["oneflow", "vcenter", "support", "nsx"],
Sep 15 11:55:02 frontend.one opennebula-sunstone[58888]:  :private_fireedge_endpoint=>"http://localhost:2616",
Sep 15 11:55:02 frontend.one opennebula-sunstone[58888]:  :public_fireedge_endpoint=>"http://localhost:2616",
Sep 15 11:55:02 frontend.one opennebula-sunstone[58888]:  :webauthn_avail=>true,
Sep 15 11:55:02 frontend.one opennebula-sunstone[58888]:  :session_expire_time=>3600}
Sep 15 11:55:02 frontend.one opennebula-sunstone[58888]: --------------------------------------
Sep 15 11:55:06 frontend.one opennebula-sunstone[58888]: == Sinatra (v3.2.0) has taken the stage on 9869 for production with>
lines 1-22/22 (END)
```


## C. Conf système

🌞 **Ouverture firewall**

```
[bingo@frontend /]$ sudo systemctl enable --now firewalld
[bingo@frontend /]$ sudo firewall-cmd --state
running
```
```
[bingo@frontend /]$ sudo firewall-cmd --reload
success
[bingo@frontend /]$ sudo firewall-cmd --list-ports
22/tcp 2633/tcp 4124/tcp 9869/tcp 29876/tcp 4124/udp
[bingo@frontend /]$
```

