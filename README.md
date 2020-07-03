# MySQL Atomicity test

## Interactive

Open a prompt:
```
mysql -h 127.0.0.1 -u user -ppassword test_db
```

Next, execute each statement in `/tmp/sql/script.sql` manually.

Finally, you should see 2 rows:
```
select * from tbl;
```

### Logs

```
# mysql -h 127.0.0.1 -u user -ppassword test_db
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.0.20 MySQL Community Server - GPL

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create table tbl(id int primary key);
Query OK, 0 rows affected (0.02 sec)

mysql> insert into tbl values (1);
Query OK, 1 row affected (0.01 sec)

mysql> begin;
Query OK, 0 rows affected (0.01 sec)

mysql> insert into tbl values (1);
ERROR 1062 (23000): Duplicate entry '1' for key 'tbl.PRIMARY'
mysql> insert into tbl values (2);
Query OK, 1 row affected (0.00 sec)

mysql> commit;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from tbl;
+----+
| id |
+----+
|  1 |
|  2 |
+----+
2 rows in set (0.00 sec)
```

## Non-interactive

(you need to drop table before this)

Execute the all statements via stdin:
```
mysql -h 127.0.0.1 -u user -ppassword test_db < /tmp/sql/script.sql
```

Finally, open prompt and check the rows:
```
select * from tbl;
```

You can see just a row in this case.

### Logs

```
# mysql -h 127.0.0.1 -u user -ppassword test_db < /tmp/sql/script.sql
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 1062 (23000) at line 4: Duplicate entry '1' for key 'tbl.PRIMARY'
# mysql -h 127.0.0.1 -u user -ppassword test_db
mysql: [Warning] Using a password on the command line interface can be insecure.
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 8.0.20 MySQL Community Server - GPL

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> select * from tbl;
+----+
| id |
+----+
|  1 |
+----+
1 row in set (0.00 sec)
```
