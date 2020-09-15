# MySQL Commands Collection

```sql

MariaDB [cdb]> describe item_project;
+-------------+------------------+------+-----+---------+----------------+
| Field       | Type             | Null | Key | Default | Extra          |
+-------------+------------------+------+-----+---------+----------------+
| id          | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| name        | varchar(64)      | NO   | UNI | NULL    |                |
| description | varchar(256)     | YES  |     | NULL    |                |
+-------------+------------------+------+-----+---------+----------------+
3 rows in set (0.004 sec)


MariaDB [cdb]> describe user_info;
+-------------+------------------+------+-----+---------+----------------+
| Field       | Type             | Null | Key | Default | Extra          |
+-------------+------------------+------+-----+---------+----------------+
| id          | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| username    | varchar(16)      | NO   | UNI | NULL    |                |
| first_name  | varchar(16)      | NO   | MUL | NULL    |                |
| last_name   | varchar(16)      | NO   |     | NULL    |                |
| middle_name | varchar(16)      | YES  |     | NULL    |                |
| email       | varchar(64)      | YES  |     | NULL    |                |
| password    | varchar(256)     | YES  |     | NULL    |                |
| description | varchar(256)     | YES  |     | NULL    |                |
+-------------+------------------+------+-----+---------+----------------+
8 rows in set (0.001 sec)

MariaDB [cdb]> describe user_group;
+-------------+------------------+------+-----+---------+----------------+
| Field       | Type             | Null | Key | Default | Extra          |
+-------------+------------------+------+-----+---------+----------------+
| id          | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| name        | varchar(64)      | NO   | UNI | NULL    |                |
| description | varchar(256)     | YES  |     | NULL    |                |
+-------------+------------------+------+-----+---------+----------------+
3 rows in set (0.001 sec)


MariaDB [cdb]> describe user_group;
+-------------+------------------+------+-----+---------+----------------+
| Field       | Type             | Null | Key | Default | Extra          |
+-------------+------------------+------+-----+---------+----------------+
| id          | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| name        | varchar(64)      | NO   | UNI | NULL    |                |
| description | varchar(256)     | YES  |     | NULL    |                |
+-------------+------------------+------+-----+---------+----------------+
3 rows in set (0.001 sec)




MariaDB [cdb]> describe user_group_list;
+---------------+------------------+------+-----+---------+-------+
| Field         | Type             | Null | Key | Default | Extra |
+---------------+------------------+------+-----+---------+-------+
| user_group_id | int(11) unsigned | NO   | PRI | NULL    |       |
| list_id       | int(11) unsigned | NO   | PRI | NULL    |       |
+---------------+------------------+------+-----+---------+-------+
2 rows in set (0.002 sec)

MariaDB [cdb]> describe user_group_setting ;
+-----------------+------------------+------+-----+---------+----------------+
| Field           | Type             | Null | Key | Default | Extra          |
+-----------------+------------------+------+-----+---------+----------------+
| id              | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| user_group_id   | int(11) unsigned | NO   | MUL | NULL    |                |
| setting_type_id | int(11) unsigned | NO   | MUL | NULL    |                |
| value           | varchar(64)      | YES  |     | NULL    |                |
+-----------------+------------------+------+-----+---------+----------------+
4 rows in set (0.002 sec)



```

