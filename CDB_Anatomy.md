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

## MariaDB configuration

The following comments were made in <https://github.com/AdvancedPhotonSource/ComponentDB/issues/657>

### Issues

While configuring MariaDB database, I have issues that two sql files are missing. I don't use the provided scripts (for MariaDB) in order to understand their sql dependencies, because I use the system provided MariaDB instead of `support` one. So far with the latest commit def2da9, I can create all tables, views, and stored_procedures, and fill all data by using sql files within `db/sql/{static,clean}`  except the following two sql files.

 One is `populate_item_element_history.sql` and the other is `populate_property_metadata_history.sql`. According to the following codes:

<https://github.com/AdvancedPhotonSource/ComponentDB/blob/def2da906dc1aaf277d66989fcbb223a07ff8511/sbin/cdb_create_db.sh#L222>

<https://github.com/AdvancedPhotonSource/ComponentDB/blob/def2da906dc1aaf277d66989fcbb223a07ff8511/sbin/cdb_create_db.sh#L255>

I think, they are in the `db/sql/clean` path according to `sbin/cdb_create_db.sh`, but I cannot find them in that path. It looks like one (`item_element_history`) of codes remains in `update/updateTo3.9.0.sql such as

<https://github.com/AdvancedPhotonSource/ComponentDB/blob/def2da906dc1aaf277d66989fcbb223a07ff8511/db/sql/updates/updateTo3.9.0.sql#L17-L45>

<https://github.com/AdvancedPhotonSource/ComponentDB/blob/def2da906dc1aaf277d66989fcbb223a07ff8511/db/sql/updates/updateTo3.9.0.sql#L53-L98>

But I cannot find any information on `populate_property_metadata_history.sql`.

Could you help me to move a bit further about configuring it?

With `make clean-db`, I've found two following messages

```bash
populate_item_element_history.sql not found, skipping item_element_history update
.....
populate_property_metadata_history.sql not found, skipping property_metadata_history update
```

So, the script `cdb_create_db.bash` cannot stop even if there is a missing sql file.  

Is it ok to run cdb without two sql configurations? Or should we add two files properly when we configure the mysql (mariaDB) from scratch?

### Approach

However, two tables are created by `create_db_tables.sql`.

```mysql

item_element_history
+--------------------------------+----------------------+------+-----+---------+----------------+
| Field                          | Type                 | Null | Key | Default | Extra          |
+--------------------------------+----------------------+------+-----+---------+----------------+
| id                             | int(11) unsigned     | NO   | PRI | NULL    | auto_increment |
| snapshot_element_name          | varchar(64)          | YES  |     | NULL    |                |
| item_element_id                | int(11) unsigned     | YES  | MUL | NULL    |                |
| snapshot_parent_name           | varchar(256)         | YES  |     | NULL    |                |
| parent_item_id                 | int(11) unsigned     | YES  | MUL | NULL    |                |
| snapshot_contained_item_1_name | varchar(256)         | YES  |     | NULL    |                |
| contained_item_id1             | int(11) unsigned     | YES  | MUL | NULL    |                |
| snapshot_contained_item_2_name | varchar(256)         | YES  |     | NULL    |                |
| contained_item_id2             | int(11) unsigned     | YES  | MUL | NULL    |                |
| derived_from_item_element_id   | int(11) unsigned     | YES  | MUL | NULL    |                |
| is_required                    | tinyint(1)           | YES  |     | 0       |                |
| description                    | varchar(256)         | YES  |     | NULL    |                |
| sort_order                     | float(10,2) unsigned | YES  |     | NULL    |                |
| entered_on_date_time           | datetime             | NO   |     | NULL    |                |
| entered_by_user_id             | int(11) unsigned     | NO   |     | NULL    |                |
+--------------------------------+----------------------+------+-----+---------+----------------+
```

```mysql
property_metadata_history
+---------------------------+------------------+------+-----+---------+----------------+
| Field                     | Type             | Null | Key | Default | Extra          |
+---------------------------+------------------+------+-----+---------+----------------+
| id                        | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| property_value_history_id | int(11) unsigned | NO   | MUL | NULL    |                |
| metadata_key              | varchar(64)      | NO   |     | NULL    |                |
| metadata_value            | varchar(256)     | YES  |     | NULL    |                |
+---------------------------+------------------+------+-----+---------+----------------+
```

## `table item_element_history`

* master branch

```bash
(master)$ git grep -r "item_element_history"
db/sql/create_cdb_tables.sql:-- Table `item_element_history`
db/sql/create_cdb_tables.sql:DROP TABLE IF EXISTS `item_element_history`;
db/sql/create_cdb_tables.sql:CREATE TABLE `item_element_history` (
db/sql/create_cdb_tables.sql:  KEY `item_element_history_k1` (`item_element_id`),
db/sql/create_cdb_tables.sql:  KEY `item_element_history_k2` (`parent_item_id`),
db/sql/create_cdb_tables.sql:  KEY `item_element_history_k3` (`contained_item_id1`),
db/sql/create_cdb_tables.sql:  KEY `item_element_history_k4` (`contained_item_id2`),
:...skipping...
db/sql/create_cdb_tables.sql:-- Table `item_element_history`
db/sql/create_cdb_tables.sql:DROP TABLE IF EXISTS `item_element_history`;
db/sql/create_cdb_tables.sql:CREATE TABLE `item_element_history` (
db/sql/create_cdb_tables.sql:  KEY `item_element_history_k1` (`item_element_id`),
db/sql/create_cdb_tables.sql:  KEY `item_element_history_k2` (`parent_item_id`),
db/sql/create_cdb_tables.sql:  KEY `item_element_history_k3` (`contained_item_id1`),
db/sql/create_cdb_tables.sql:  KEY `item_element_history_k4` (`contained_item_id2`),
db/sql/create_cdb_tables.sql:  KEY `item_element_history_k5` (`derived_from_item_element_id`),
db/sql/create_cdb_tables.sql:  CONSTRAINT `item_element_history_fk1` FOREIGN KEY (`item_element_id`) REFERENCES `item_element` (`id`) ON UPDATE CASCADE ON DELETE SET NULL,
db/sql/create_cdb_tables.sql:  CONSTRAINT `item_element_history_fk2` FOREIGN KEY (`parent_item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE ON DELETE SET NULL,
db/sql/create_cdb_tables.sql:  CONSTRAINT `item_element_history_fk3` FOREIGN KEY (`contained_item_id1`) REFERENCES `item` (`id`) ON UPDATE CASCADE ON DELETE SET NULL,
db/sql/create_cdb_tables.sql:  CONSTRAINT `item_element_history_fk4` FOREIGN KEY (`contained_item_id2`) REFERENCES `item` (`id`) ON UPDATE CASCADE ON DELETE SET NULL,
db/sql/create_cdb_tables.sql:  CONSTRAINT `item_element_history_fk5` FOREIGN KEY (`derived_from_item_element_id`) REFERENCES `item_element` (`id`) ON UPDATE CASCADE ON DELETE SET NULL
db/sql/updates/updateTo3.9.0.sql:-- Table `item_element_history`
db/sql/updates/updateTo3.9.0.sql:DROP TABLE IF EXISTS `item_element_history`;
db/sql/updates/updateTo3.9.0.sql:CREATE TABLE `item_element_history` (
db/sql/updates/updateTo3.9.0.sql:  KEY `item_element_history_k1` (`item_element_id`),
db/sql/updates/updateTo3.9.0.sql:  KEY `item_element_history_k2` (`parent_item_id`),
db/sql/updates/updateTo3.9.0.sql:  KEY `item_element_history_k3` (`contained_item_id1`),
db/sql/updates/updateTo3.9.0.sql:  KEY `item_element_history_k4` (`contained_item_id2`),
db/sql/updates/updateTo3.9.0.sql:  KEY `item_element_history_k5` (`derived_from_item_element_id`),
db/sql/updates/updateTo3.9.0.sql:  CONSTRAINT `item_element_history_fk1` FOREIGN KEY (`item_element_id`) REFERENCES `item_element` (`id`) ON UPDATE CASCADE ON DELETE SET NULL,
db/sql/updates/updateTo3.9.0.sql:  CONSTRAINT `item_element_history_fk2` FOREIGN KEY (`parent_item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE ON DELETE SET NULL,
db/sql/updates/updateTo3.9.0.sql:  CONSTRAINT `item_element_history_fk3` FOREIGN KEY (`contained_item_id1`) REFERENCES `item` (`id`) ON UPDATE CASCADE ON DELETE SET NULL,
db/sql/updates/updateTo3.9.0.sql:  CONSTRAINT `item_element_history_fk4` FOREIGN KEY (`contained_item_id2`) REFERENCES `item` (`id`) ON UPDATE CASCADE ON DELETE SET NULL,
db/sql/updates/updateTo3.9.0.sql:  CONSTRAINT `item_element_history_fk5` FOREIGN KEY (`derived_from_item_element_id`) REFERENCES `item_element` (`id`) ON UPDATE CASCADE ON DELETE SET NULL 
db/sql/updates/updateTo3.9.0.sql:INSERT INTO item_element_history
sbin/cdb_create_db.sh:    item_element_history \
src/java/CdbWebPortal/src/java/gov/anl/aps/cdb/portal/model/db/entities/ItemElementHistory.java:@Table(name = "item_element_history")
```

* Track down all history

```bash
git log -G item_element_history --pretty=format:"%h - %an, %ar : %s"
77e089eed - Dariusz Jarosz, 7 months ago : Prepopulate techsys for cable catalog and resolve the update process. Closes #430
346810bea - Dariusz Jarosz, 9 months ago : Resolve issue with missing table for item element history in the db restore process.
e6580f230 - Dariusz Jarosz, 11 months ago : Add entities for the new item element history.
50b3908ff - Dariusz Jarosz, 11 months ago : Add new table for tracking item element history.
```

* 50b3908ff : the table `item_element_history` is shown in `/db/sql/create_db_tables.sql` and `db/sql/updates/updateTo3.9.0.sql`,
however, create_db_tables.sql has "CREATE TABE` and updateTo3.9.0.sql has `INSERT INTO`.

* e6580f230 : the same as before. now the java source is shown in
src/java/CdbWebPortal/src/java/gov/anl/aps/cdb/portal/model/db/entities/ItemElementHistory.java:@Table(name = "item_element_history")

* 346810bea : the same as e6580f230 except the list entry of `item_element_history` in `sbin/cdb_create_db.sh`.
log tells "Resolve issue with missing table for item element history in the db restore process.", but it doesn't look like what it says, still
there is no `populate_item_element_history.sql` in `db/sql/clean` path. So, it returns \
"populate_item_element_history.sql not found, skipping item_element_history update" with `make clean-db`.

* 77e089eed : the same as 346810bea except the `CREATE TABLE` in `db/sql/updates/updateTo3.9.0.sql`.

* Conclustion : OK, based on them, we need to create the `INSERT_INTO` table in `populate_item_element_hsitory.sql`. Both file has the same `CRATE TABLE` query. So, we can ignore `CREATE TABLE` of `item_element_history`. However, I can find only `INSERT INTO` in `db/sql/updates/UpdateTo3.9.0.sql`. So I create `populate_item_element_history.sql` in `ComponentDB-env/sql` by copying `INSERT INTO` from `db/sql/updates/UpdateTo3.9.0.sql`.

## `table property_metadata_history`

* master branch

```bash
$ git grep -r "property_metadata_history"
db/sql/create_cdb_tables.sql:-- Table `property_metadata_history`
db/sql/create_cdb_tables.sql:DROP TABLE IF EXISTS `property_metadata_history`;
db/sql/create_cdb_tables.sql:CREATE TABLE `property_metadata_history` (
db/sql/create_cdb_tables.sql:  UNIQUE KEY `property_metadata_history_u1` (`property_value_history_id`, `metadata_key`),
db/sql/create_cdb_tables.sql:  KEY `property_metadata_history_k1` (`property_value_history_id`),
db/sql/create_cdb_tables.sql:  CONSTRAINT `property_metadata_history_fk1` FOREIGN KEY (`property_value_history_id`) REFERENCES `property_value_history` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
sbin/cdb_create_db.sh:    property_metadata_history \
src/java/CdbWebPortal/src/java/gov/anl/aps/cdb/portal/model/db/entities/PropertyMetadataHistory.java:@Table(name = "property_metadata_history")
```

* Track down all history

```bash
$ git log -G property_metadata_history --pretty=format:"%h - %an, %ar : %s"
bee9c1f3c - Dariusz Jarosz, 11 months ago : Add the new property metadata history table to the create db script to allow user to restore information from this table after backup..
8305cf81d - Dariusz Jarosz, 11 months ago : Add property metadata history and standardize the fetching of metadata key value pairs between property value history and property value entities.
876306e0b - Dariusz Jarosz, 11 months ago : Add property metadata history table to allow for taking metadata snapshots of the property value history.
```

* 876306e0b

```bash
((876306e0b...))$ git grep -r "property_metadata_history"
```

shows that `CREATE TABLE` is shown in `db/sql/create_cdb_tables.sql`

* 8305cf81d has the same as before the previous 876306e0b except the java source which uses that table.

```java
src/java/CdbWebPortal/src/java/gov/anl/aps/cdb/portal/model/db/entities/PropertyMetadataHistory.java:@Table(name = "property_metadata_history")
```

* bee9c1f3c has the same as the previous commit 8305cf81d except `sbin/cdb_create_db.sh`. Now `property_metadata_history` entry is defined in
table list. However there is no `populate_property_metadata.sql` in `db/sql/clean` path.

* Conclusion : We can ignore `populate_property_metadata.sql` because I don't see any history to fill this table by using additional sql files.
