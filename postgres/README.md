# PosgreSQL Atomicity test

## Interactive

Open a prompt:
```
psql -U postgres
```

Execute each statement in `/tmp/sql/script.sql` manually.

The table should contain just a row:
```
select * from tbl;
```

### Logs

```
root@0ece8d01c2d2:/# psql -U postgres
psql (12.3 (Debian 12.3-1.pgdg100+1))
Type "help" for help.

postgres=# create table tbl(id int primary key);
CREATE TABLE
postgres=# insert into tbl values (1);
INSERT 0 1
postgres=# begin;
BEGIN
postgres=# insert into tbl values (1);
ERROR:  duplicate key value violates unique constraint "tbl_pkey"
DETAIL:  Key (id)=(1) already exists.
postgres=# insert into tbl values (2);
ERROR:  current transaction is aborted, commands ignored until end of transaction block
postgres=# commit;
ROLLBACK
postgres=# select * from tbl;
 id
----
  1
(1 row)
```

## Non-interactive

(you need to drop table before this)

Execute the all statements via stdin:
```
psql -U postgres < /tmp/sql/script.sql
```

Finally, open a prompt and check the table:
```
select * from tbl;
```

The table should also contain just a row.


### Logs

```
# psql -U postgres < /tmp/sql/script.sql
CREATE TABLE
INSERT 0 1
BEGIN
ERROR:  duplicate key value violates unique constraint "tbl_pkey"
DETAIL:  Key (id)=(1) already exists.
ERROR:  current transaction is aborted, commands ignored until end of transaction block
ROLLBACK
# psql -U postgres
psql (12.3 (Debian 12.3-1.pgdg100+1))
Type "help" for help.

postgres=# select * from tbl;
 id
----
  1
(1 row)
```
