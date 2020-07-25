# CDB Environment Setting

```bash
source setup.sh
```

## Environment Variables

* `CDB_HOST_ARCH`   : ```bash uname -sm | tr -s '[:upper:][:blank:]' '[:lower:][\-]'```

* `CDB_ROOT_DIR`    : Where the source codes are located. Typically, this is the git clone directory `ComponentDB`.

* `CDB_INSTALL_DIR` : CDB Installation Path. Default is `$CDB_ROOT_DIR/..`

* `CDB_DATA_DIR`    : CDB data Path. Default is `CDB_INSTALL_DIR/data`. This directory has two more sub directories

```bash
ComponentDB-env (master)$ tree data/
data/
├── [jhlee    4.0K]  log
└── [jhlee    4.0K]  propertyValue
```

* `CDB_VAR_DIR`     : CDB var Path. Default is `$CDB_INSTALL_DIR/var`.

* `CDB_SHORT_HOSTNAME` : ```bash hostname -s```

* `CDB_SUPPORT_DIR` : The support services' installation location. Default is `$CDB_INSTALL_DIR/support-$CDB_SHORT_HOSTNAME`

* `CDB_GLASSFISH_DIR` : `$CDB_SUPPORT_DIR/payara/$CDB_HOST_ARCH`

* `CDB_PYTHON_DIR` : `PYTHONPATH`

** `$CDB_SUPPORT_DIR/python/$CDB_HOST_ARCH`

** `$CDB_ROOT_DIR/src/python`

** `$CDB_ROOT_DIR/tools/developer_tools/python-client`

** `$CDB_INSTALL_DIR/etc` : undefined path, however this patch contains a few deployment files.

```bash
ComponentDB-env (master)$ tree etc/
etc/
├── [jhlee       4]  cdb.db.passwd
├── [jhlee     563]  cdb.deploy.conf
├── [jhlee    9.8K]  cdb.openssl.cnf
└── [jhlee    4.0K]  plugins-cdb
```

## PATH

The script adds the following path in `PATH`

```bash
$CDB_GLASSFISH_DIR/bin
$CDB_SUPPORT_DIR/mysql/$CDB_HOST_ARCH/bin
$CDB_SUPPORT_DIR/netbeans/currentNetbeans/bin
$CDB_ROOT_DIR/bin
$CDB_SUPPORT_DIR/ant/bin
$CDB_SUPPORT_DIR/anaconda/$CDB_HOST_ARCH/bin
$CDB_SUPPORT_DIR/java/$CDB_HOST_ARCH/bin
```

## Example

* Before sourcing,

```bash
$ printenv |grep CDB_
$ echo $PATH
/home/jhlee/programs/root/bin:/home/jhlee/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
```

* After sourcing,

```bash
ComponentDB-env (master)$ source ComponentDB-src/setup.sh
ComponentDB-env (master)$ printenv |grep CDB_
CDB_SUPPORT_DIR=/home/jhlee/gitsrc/ComponentDB-env/support-parity
CDB_INSTALL_DIR=/home/jhlee/gitsrc/ComponentDB-env
CDB_GLASSFISH_DIR=/home/jhlee/gitsrc/ComponentDB-env/support-parity/payara/linux-x86_64
CDB_ROOT_DIR=/home/jhlee/gitsrc/ComponentDB-env/ComponentDB-src
CDB_DATA_DIR=/home/jhlee/gitsrc/ComponentDB-env/data
CDB_PYTHON_DIR=/home/jhlee/gitsrc/ComponentDB-env/support-parity/python/linux-x86_64
ComponentDB-env (master)$ echo $PATH
/home/jhlee/gitsrc/ComponentDB-env/support-parity/python/linux-x86_64/bin:/home/jhlee/gitsrc/ComponentDB-env/support-parity/anaconda/linux-x86_64/bin:/home/jhlee/gitsrc/ComponentDB-env/ComponentDB-src/bin:/home/jhlee/gitsrc/ComponentDB-env/support-parity/ant/bin:/home/jhlee/gitsrc/ComponentDB-env/support-parity/java/linux-x86_64/bin:/home/jhlee/gitsrc/ComponentDB-env/support-parity/payara/linux-x86_64/bin:/home/jhlee/programs/root/bin:/home/jhlee/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
```
