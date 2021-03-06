# CDB Web Service

## Setup

```bash
$ make install.cdbweb
$ make sd_start
$ make sd_status
     1  ● cdbweb.service - CDB Web Service
     2     Loaded: loaded (/etc/systemd/system/cdbweb.service; enabled; vendor preset: enabled)
     3     Active: active (running) since Sun 2020-09-13 00:17:51 PDT; 11ms ago
     4       Docs: https://github.com/AdvancedPhotonSource/ComponentDB
     5   Main PID: 11959 (python)
     6      Tasks: 1 (limit: 4915)
     7     Memory: 2.8M
     8     CGroup: /system.slice/cdbweb.service
     9             └─11959 /opt/ComponentDB/python/linux-x86_64/bin/python /opt/ComponentDB/python/cdb/cdb_web_service/service/cdbWebService.py --pid-file /opt/ComponentDB/var/run/cdb.cdb-web-service.pid --config-file /opt/ComponentDB/etc/cdb.cdb-web-service.conf
```

* Redesigned CDB Web service CLI bash scripts will be located in `CDB_INSTALL_LOCATION/bin`.

```bash
$ source /opt/ComponentDB/setCdbWeb.bash

Set the CDB Web Service Environment as follows:
THIS Source NAME    : setCdbWeb.bash
THIS Source PATH    : /opt/ComponentDB
CDB BIN PATH        : /opt/ComponentDB/bin

Enjoy ComponentDB Web Service CLI!

$ get-users.bash
id=1 username=cdbuser firstName=Han lastName=Lee middleName=NULL email=jeonglee@lbl.gov description=ComponentDB System Account - Local User

$ get-user-groups.bash
id=1 name=CDB_ADMIN description=System Admin Group
```

```bash
make uninstall.cdbweb
```

## Service Rules

* `install.cdbpython` : `build.cdbpython` `conf.cdbpython`

* `build.cdbpython` : Keep the CDB local Python environment by using `support/bin/install_python_packages.sh`

* `conf.cdbpython`  : Move all CDB Pythons (support/python/linux-x86_64, src/python/cdb, tools/developer_tools/python-client, tools/developer_tools/cdb_plugin, tools/developer_tools/utilities) into `CDB_PYTHON_ROOT_DIR`

* `conf.cdbwebscript` : Create an universal bash script to do CDB Web Service, and install it into `CDB_INSTALL_LOCATION`

* `conf.cdbweb` :  Generate a global configuration file for CDB Web Service

* `db.cdbweb`   : Generate a MySQL DB / MariaDB DB user password file

* `install.cdbweb` : Install generated configuration and db password files into `CDB_ETC_DIR`

## Systemd Rules

### `conf.systemd`

Generate the systemd file for CDB Web Service such as `cdbweb.service`

### `install.systemd`

Install `cdbweb.service` in the system systemd path

### sd_enable, sd_disble, sd_start, sd_status, sd_restart, sd_stop

Systemd alias commands such as

```bash
systemctl enable cdbweb
systemctl disable cdbweb
systemctl start cdbweb
systemctl status cdbweb
systemctl restart cdbweb
systemctl stop cdbweb
```

### sd_clean

Remove the installed systemd unit file from the system

## Pratical Command Examples

```bash
$ add-user.bash --username jeonglee --first-name=Han --last-name=Lee --middle-name=none --email="jeonghan.lee@gmail.com" --description="Test account" --password="jeonglee"

$get-users.bash
id=1 username=cdbuser firstName=Han lastName=Lee middleName=NULL email=jeonglee@lbl.gov description=ComponentDB System Account - Local User
id=2 username=jeonglee firstName=Han lastName=Lee middleName=none email=jeonghan.lee@gmail.com description=Test account

```

```bash
add-item-project.bash --name=ALSU
```

### Detailed Commands

See [./../cdbweb-cli/README.md](./../cdbweb-cli/README.md)
