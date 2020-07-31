# Configuration Env

Configuration Environment for ComponentDB at <https://github.com/AdvancedPhotonSource/ComponentDB>

## Requirements

### Download the ComponentDB source under this repository

```bash
make init
```

* If there are patch files, please run

```bash
make patch.apply
```

### Install packages

```bash
make install.pkgs
```

### MariaDB configuration

* Check the mariadb status

```bash
$ systemctl status mariadb
● mariadb.service - MariaDB 10.3.22 database server
   Loaded: loaded (/lib/systemd/system/mariadb.service; enabled; vendor preset:
   Active: active (running) since Wed 2020-07-29 15:28:12 PDT; 1h 54min ago
     Docs: man:mysqld(8)
```

* Define all DB varialbes in `configure/CONFIG_COMMON` or its `CONFIG_COMMON.local`. For example,

```bash
DB_ADMIN_HOSTS="127.0.0.1"
DB_ADMIN="admin"
DB_ADMIN_PASS="admin"
DB_HOST_IPADDR="127.0.0.1"
DB_HOST_PORT="3306"
DB_HOST_NAME="localhost"
DB_NAME="cdb"
DB_USER="cdb"
DB_USER_PASS="cdb"
DB_CHAR_SET="utf8"
```

* Generate `mariadb.conf` file for a script

```bash
make db.conf
```

* Secure Setup and add administor : only need to do at the beginning of MariaDB configuration

```bash
make db.init
```

* Create DB for ComponentDB

```bash
make db.create
make db.show
```

* Create all tables and populate all sql files for ComponentDB

```bash
make cdb.create
make cdb.show
```

* Update the local user password

```bash
make cdb.admin
```

#### Reset the Database

```bash
make db.drop
make db.create
make cdb.create
make cdb.admin
```

* Further information about CDB MariaDB configuration, please see [docs/README.mariaDB.md](MariaDB README)

### Paraya Server Configuration

Almost generic installation and configuration are done in the external repository. Please see it the further configuration [1].

* Check the payara service

```bash
systemctl status payara
```

* Start the Paraya service

```bash
sudo systemctl start payara
```

* `makefile` rules

```bash
make jdbc.conf             : Build   payara_mariadb_jdbc_template.xml in SITE_TEMPLATE_PATH
make jdbc.conf.view        : Print   payara_mariabd_jdbc_template.xml
make jdbc.install          : Install it to the running payara server
make jdbc.ping             : Do ping-connection-pool
make jdbc.list             : Do list-jdbc-connection-pools
make jdbc.flush            : Do flush-connection-pool
make jdbc.uninstall        : Delete resource and connection-pool
make jdbc.resouces.rm      : Do delete-jdbc-resource
make jdbc.pool.rm          : Do delete-jdbc-connection-pool
```

## Build

```bash

make build
make deploy.cdb
```

|![FFCDB1](docs/ff_cdb_about.png)|
| :---: |
|**Figure 1** Firefox CDB About Page Screenshot.|

|![FFCDB2](docs/ff_cdb_catalog.png)|
| :---: |
|**Figure 2** Chrome CDB Catalog Page Screenshot.|

|![CRCDB](docs/chrome_cdb_about.png)|
| :---: |
|**Figure 3** Chrome CDB About Page Screenshot.|

## References

[1] <https://github.com/jeonghanlee/Payara-env>
