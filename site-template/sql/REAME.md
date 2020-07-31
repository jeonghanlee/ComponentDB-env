# User Password

```sql
MariaDB [(none)]> use cdb;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

MariaDB [cdb]> select * from user_info inner join user_user_group on user_info.id = user_user_group.user_id;
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+
| id | username | first_name | last_name      | middle_name | email            | password | description | user_id | user_group_id |
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+
|  1 | cdb      | CDB        | System Account | NULL        | jeonglee@lbl.gov | NULL     | NULL        |       1 |             1 |
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+
1 row in set (0.001 sec)


MariaDB [cdb]> select * from user_info inner join user_user_group on user_info.id = user_user_group.user_id
    -> inner join user_group on user_group.id = user_user_group.user_group_id;
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+----+-----------+--------------------+
| id | username | first_name | last_name      | middle_name | email            | password | description | user_id | user_group_id | id | name      | description        |
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+----+-----------+--------------------+
|  1 | cdb      | CDB        | System Account | NULL        | jeonglee@lbl.gov | NULL     | NULL        |       1 |             1 |  1 | CDB_ADMIN | System Admin Group |
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+----+-----------+--------------------+
1 row in set (0.001 sec)

MariaDB [cdb]> select * from user_info inner join user_user_group on user_info.id = user_user_group.user_id  inner join user_group on user_group.id = user_user_group.user_group_id where user_group.name = 'CDB_ADMIN';
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+----+-----------+--------------------+
| id | username | first_name | last_name      | middle_name | email            | password | description | user_id | user_group_id | id | name      | description        |
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+----+-----------+--------------------+
|  1 | cdb      | CDB        | System Account | NULL        | jeonglee@lbl.gov | NULL     | NULL        |       1 |             1 |  1 | CDB_ADMIN | System Admin Group |
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+----+-----------+--------------------+
1 row in set (0.001 sec)

MariaDB [cdb]> select * from user_info inner join user_user_group on user_info.id = user_user_group.user_id  inner join user_group on user_group.id = user_user_group.user_group_id where user_group.name = 'CDB_ADMIN' and user_info.password is not null;
Empty set (0.000 sec)

MariaDB [cdb]> select * from user_info inner join user_user_group on user_info.id = user_user_group.user_id  inner join user_group on user_group.id = user_user_group.user_group_id where user_group.name = 'CDB_ADMIN' and user_info.password is null;
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+----+-----------+--------------------+
| id | username | first_name | last_name      | middle_name | email            | password | description | user_id | user_group_id | id | name      | description        |
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+----+-----------+--------------------+
|  1 | cdb      | CDB        | System Account | NULL        | jeonglee@lbl.gov | NULL     | NULL        |       1 |             1 |  1 | CDB_ADMIN | System Admin Group |
+----+----------+------------+----------------+-------------+------------------+----------+-------------+---------+---------------+----+-----------+--------------------+
1 row in set (0.001 sec)

MariaDB [cdb]> select username from user_info inner join user_user_group on user_info.id = user_user_group.user_id  inner join user_group on user_group.id = user_user_group.user_group_id where user_group.name = 'CDB_ADMIN' and user_info.password is null;
+----------+
| username |
+----------+
| cdb      |
+----------+
1 row in set (0.001 sec)
```

```bash
bash scripts/mariadb_setup.bash queryFile site-template/sql/check_cdb_admin.sql
bash scripts/mariadb_setup.bash querySFile site-template/sql/check_cdb_admin.sql
```

```bash
$ bash scripts/mariadb_setup.bash querySFile site-template/sql/check_cdb_admin_is_null.sql
username
cdb

bash scripts/mariadb_setup.bash querySFile site-template/sql/check_cdb_admin_is_null.sql "-N"
cdb
```


SELECT username from user_info WHERE username='cdb';


MariaDB [cdb]> UPDATE user_info SET password = 'aaaaaaa' WHERE username='cdb';



UPDATE user_info SET password = 'NULL' WHERE username='cdb';


SELECT *  FROM user_info;



