# MariaDB Configuration (Old, not valid)

There are several issues on the upstream repository of ComponentDB as follows:

* <https://github.com/AdvancedPhotonSource/ComponentDB/issues/658>

* <https://github.com/AdvancedPhotonSource/ComponentDB/issues/657>

Thus, we have to develop our one way to handle the CDB MariaDB.

## Procedure

```bash
$ systemctl status mariadb
mariadb.service - MariaDB 10.3.22 database server
   Loaded: loaded (/lib/systemd/system/mariadb.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2020-07-15 09:39:26 PDT; 7h ago
     Docs: man:mysqld(8)
           https://mariadb.com/kb/en/library/systemd/
  Process: 850 ExecStartPre=/usr/bin/install -m 755 -o mysql -g root -d /var/run/mysqld (code=exited, status=0/SUCCESS)
  Process: 862 ExecStartPre=/bin/sh -c systemctl unset-environment _WSREP_START_POSITION (code=exited, status=0/SUCCESS)
  Process: 883 ExecStartPre=/bin/sh -c [ ! -e /usr/bin/galera_recovery ] && VAR= ||   VAR=`/usr/bin/galera_recovery`; [ $? -eq 0 ]   && systemctl set-environment _WSREP_START_POSI
  Process: 1074 ExecStartPost=/bin/sh -c systemctl unset-environment _WSREP_START_POSITION (code=exited, status=0/SUCCESS)
  Process: 1076 ExecStartPost=/etc/mysql/debian-start (code=exited, status=0/SUCCESS)
 Main PID: 972 (mysqld)
   Status: "Taking your SQL requests now..."
    Tasks: 31 (limit: 4915)
   Memory: 103.4M
   CGroup: /system.slice/mariadb.service
           └─972 /usr/sbin/mysqld
```

* step 0

```bash
make db.init
```

* step 1

```bash
make db.show
make db.create
make db.show
```

* step 2

Due to one issue which was mentioned before, we have to apply a patch file to the upstream repository before creating and populating database.

```bash
make sql.Fill
make sql.Show
```

* reset step 1 and step 2

```bash
make db.drop
```
