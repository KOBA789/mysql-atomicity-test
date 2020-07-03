create table tbl(id int primary key);
insert into tbl values (1);
begin;
insert into tbl values (1);
insert into tbl values (2);
commit;
