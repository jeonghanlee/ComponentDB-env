# `mariadb_setup.bash`

```bash

Usage    : scripts/mariadb_setup.bash <arg>

          <arg>              : info

          ssetup             : mariaDB secure installation
          adminAdd           : add the admin account

          dbCreate           : create the DB -cdb- at -localhost-
          dbDrop             : drop   the DB -cdb- at -localhost-
          dbShow             : show all dbs exist
          tableCreate        : create the tables
          tableDrop          : drop   the tables
          tableShow          : show   the tables
          viewCreate         : create the views
          viewDrop           : drop   the views
          viewShow           : show   the views
          sProcCreate        : create the stored_procedures
          sProcDrop          : drop   the stored_procedures
          sProcShow          : show   the stored_procedures

          allCreate          : create the tables, views, and stored_procedures
          allViews           : show the tables, views, and stored_procedures
          allDrop            : drop the tables, views, and stored_procedures

          query "sql query"  : Send any sql query to DB -cdb-
```

## `secureSetup`

When MariaDB / MySQL is running from scratch, this procedure will do `mysql secure installation` partly. They call the individual queries based on the functions in `mysql_secure_installation`.

```bash
remove_anonymous_users()
remove_remote_root()
remove_test_database()
reload_privilege_tables()
```

## `adminAdd`

We add the admin account in order to access MariaDB through ip address with its portnumber, because the default root accout uses the unix socket.

## `dbCreate`

It creates the default database `cdb`. After this, one can check its status via `dbShow`. One can create a different database name with the second argument as follows:

```bash
bash scripts/mariadb_setup.bash dbCreate test
```

## `dbShow`

It shows the exist databases in the current MariaDB server.

```bash
bash scripts/mariadb_setup.bash dbShow
>>>>>                      cdb was found.
>>>>>       information_schema was found.
>>>>>                    mysql was found.
>>>>>       performance_schema was found.
```

## `dbDrop`

One can drop any database in the MariaDB server. The default value is `cdb`.

```bash
bash scripts/mariadb_setup.bash dbDrop
```

```bash
$ bash scripts/mariadb_setup.bash dbCreate test
>> Create the Database test if not exists with uft-8 and its user name cdb

$ bash scripts/mariadb_setup.bash dbShow
>>>>>                      cdb was found.
>>>>>       information_schema was found.
>>>>>                    mysql was found.
>>>>>       performance_schema was found.
>>>>>                     test was found.

$ bash scripts/mariadb_setup.bash dbDrop test
>> Drop the Database test

$ bash scripts/mariadb_setup.bash dbShow
>>>>>                      cdb was found.
>>>>>       information_schema was found.
>>>>>                    mysql was found.
>>>>>       performance_schema was found.
```

## `tableCreate`

```bash
bash scripts/mariadb_setup.bash tableCreate
```

## `tableShow`

Show all tables with `Table_type=BASE TABLE`.

```bash
$ bash scripts/mariadb_setup.bash tableShow
>>    1/   1/  63<<                allowed_child_entity_type
>>    2/   2/  63<<                      allowed_entity_type
>>    3/   3/  63<<               allowed_entity_type_domain
>>    4/   4/  63<<                  allowed_property_domain
>>    5/   5/  63<<          allowed_property_metadata_value
>>    6/   6/  63<<                   allowed_property_value
>>    7/   7/  63<<                               attachment
>>    8/   8/  63<<                                connector
>>    9/   9/  63<<                       connector_property
>>   10/  10/  63<<                           connector_type
>>   11/  11/  63<<                                   domain
>>   12/  12/  63<<                              entity_info
```

## `tableDrop`

```bash
bash scripts/mariadb_setup.bash tableDrop
```

## `viewCreate`

Create VIEW tables by using `create_view.sql`. The second argument can be used for other sql CREATE VIEW files.

## `viewDrop`

Drop all VIEW tables in the database.

## `viewShow`

Show all tables with `Table_type=VIEW`.

```bash
$ bash scripts/mariadb_setup.bash viewShow

>>    1/   1/   3<<        v_item_connector_domain_inventory
>>    2/   2/   3<< v_item_domain_inventory_connector_status
>>    3/   3/   3<<                      v_item_self_element
```

## `sProcCreate`

```bash
bash scripts/mariadb_setup.bash sProcCreate
```

## `sProcDrop`

```bash
bash scripts/mariadb_setup.bash sProcDrop
```

## `sProcShow`

```bash
bash scripts/mariadb_setup.bash sProcShow
>>    1/   5<<  available_connectors_for_inventory_item
>>    2/   5<<  inventory_items_with_avaiable_connector
>>    3/   5<<                is_item_attributes_unique
>>    4/   5<<                 is_item_attributes_valid
>>    5/   5<<     items_with_write_permission_for_user
```

## `allCreate`

* tableCreate
* viewCreate
* sProcCreate

## `allShow`

* tableShow
* viewShow
* sProcShow

## `allDrop`

* tableDrop
* viewDrop
* sProcDrop

## `query`

Build any sql qurey after this.

```bash
$ bash scripts/mariadb_setup.bash query "SELECT SCHEMA_NAME 'database', default_character_set_name 'charset', DEFAULT_COLLATION_NAME 'collation' FROM information_schema.SCHEMATA;"
+--------------------+---------+--------------------+
| database           | charset | collation          |
+--------------------+---------+--------------------+
| information_schema | utf8    | utf8_general_ci    |
| cdb                | utf8mb4 | utf8mb4_general_ci |
+--------------------+---------+--------------------+
```

* Get the schema of a table

There are several ways we can do

* `describe [dbname.]table_name;`

* `SHOW COLUMNS from table_name;`

* `explain [dbname.]table_name;`

The output result is identical, so I prefer to use `explain`.

```bash
bash scripts/mariadb_setup.bash query "describe item_element_history;"
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

```bash
$ bash scripts/mariadb_setup.bash query "explain property_metadata_history;"
>> command :
mysql --user=cdb --password=* --port=3306 --host=127.0.0.1 cdb --execute="explain property_metadata_history;"
>>
+---------------------------+------------------+------+-----+---------+----------------+
| Field                     | Type             | Null | Key | Default | Extra          |
+---------------------------+------------------+------+-----+---------+----------------+
| id                        | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| property_value_history_id | int(11) unsigned | NO   | MUL | NULL    |                |
| metadata_key              | varchar(64)      | NO   |     | NULL    |                |
| metadata_value            | varchar(256)     | YES  |     | NULL    |                |
+---------------------------+------------------+------+-----+---------+----------------+

$ bash scripts/mariadb_setup.bash query "describe property_metadata_history;"
>> command :
mysql --user=cdb --password=* --port=3306 --host=127.0.0.1 cdb --execute="describe property_metadata_history;"
>>
+---------------------------+------------------+------+-----+---------+----------------+
| Field                     | Type             | Null | Key | Default | Extra          |
+---------------------------+------------------+------+-----+---------+----------------+
| id                        | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| property_value_history_id | int(11) unsigned | NO   | MUL | NULL    |                |
| metadata_key              | varchar(64)      | NO   |     | NULL    |                |
| metadata_value            | varchar(256)     | YES  |     | NULL    |                |
+---------------------------+------------------+------+-----+---------+----------------+

$ bash scripts/mariadb_setup.bash query "show columns from property_metadata_history;"
>> command :
mysql --user=cdb --password=* --port=3306 --host=127.0.0.1 cdb --execute="show columns from property_metadata_history;"
>>
+---------------------------+------------------+------+-----+---------+----------------+
| Field                     | Type             | Null | Key | Default | Extra          |
+---------------------------+------------------+------+-----+---------+----------------+
| id                        | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| property_value_history_id | int(11) unsigned | NO   | MUL | NULL    |                |
| metadata_key              | varchar(64)      | NO   |     | NULL    |                |
| metadata_value            | varchar(256)     | YES  |     | NULL    |                |
+---------------------------+------------------+------+-----+---------+----------------+

```
