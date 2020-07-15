# CDB Installation Procedure Anatomy

## `make support`

```bash
SRC_PATH/sbin/cdb_install_support.sh


CDB_ROOT_DIR : SRC_PATH


CDB_INSTALL_DIR=$CDB_ROOT_DIR/..
CDB_SHORT_HOSTNAME=`hostname -s`
CDB_SUPPORT_DIR=$CDB_INSTALL_DIR/support-$CDB_SHORT_HOSTNAME
CDB_DATA_DIR=$CDB_INSTALL_DIR/data
```

* copy all $(SRC_PATH)/support to $(CDB_SUPPORT_DIR)

* $CDB_SUPPORT_DIR/bin/clean_all.sh
  remove all packages inside $(CDB_SUPPORT_DIR)/
  java, ant, glassfish, python, mysql, anaconda

* $CDB_SUPPORT_DIR/bin/install_all.sh
  it contain the following scripts

** install_anaconda.sh

```bash
curl -o Anaconda3-2020.02-Linux-x86_64.sh  https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
sh Anaconda3-2020.02-Linux-x86_64.sh -b -s $CDB_SUPPORT_DIR/anaconda
```

** install_java_packages.sh

*** install_java.sh

```bash
curl -o openjdk-11+28_linux-x64_bin.tar.gz https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
extract them into $(CDB_SUPPORT_DIR)/java
```

*** install_ant.sh

```bash
curl -L -O http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.3-bin.tar.gz
extract them into $(CDB_SUPPORT_DIR)/ant
```

*** install_glassfish.sh

This is not the glassfish, but paraya,
<https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/5.192/payara-5.192.zip>

```bash
payara/linux-x86_64/bin/asadmin change-master-password --savemasterpassword=true "production"
```

```bash
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format
Convert them to pkcs12

KEYSTORE Certificates

/home/jhlee/gitsrc/ComponentDB-env/support-parity/java/linux-x86_64/bin/keytool -importkeystore -srckeystore /home/jhlee/gitsrc/ComponentDB-env/support-parity/payara/linux-x86_64/glassfish/domains/production/config/keystore.jks -destkeystore /home/jhlee/gitsrc/ComponentDB-env/support-parity/payara/linux-x86_64/glassfish/domains/production/config/keystore.jks -deststoretype pkcs12

Save the master password into

/home/jhlee/gitsrc/ComponentDB-env/support-parity/java/linux-x86_64/bin/keytool -list -keystore payara/linux-x86_64/glassfish/domains/production/config/keystore.jks -storepass "master passwd"

CA Certificates

/home/jhlee/gitsrc/ComponentDB-env/support-parity/java/linux-x86_64/bin/keytool -importkeystore -srckeystore /home/jhlee/gitsrc/ComponentDB-env/support-parity/payara/linux-x86_64/glassfish/domains/production/config/cacerts.jks -destkeystore /home/jhlee/gitsrc/ComponentDB-env/support-parity/payara/linux-x86_64/glassfish/domains/production/config/keystore.jks -deststoretype pkcs12



/home/jhlee/gitsrc/ComponentDB-env/support-parity/java/linux-x86_64/bin/keytool -list -keystore /home/jhlee/gitsrc/ComponentDB-env/support-parity/payara/linux-x86_64/glassfish/domains/production/config/cacerts.jks -storepass "master passwd"
```

```bash
$binDir/install_python_packages.sh || exit 1
```
