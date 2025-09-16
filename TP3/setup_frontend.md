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
... (126lignes restantes)