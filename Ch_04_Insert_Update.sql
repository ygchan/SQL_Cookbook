-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Chapter 04: Inserting, Updating, Deleting
-- Inserting new records into the database
-- Updating existing records
-- Deleting records that you no longer want

-- It is more efficient to use a set-based approach (inserting many rows at
-- a time). Update the whole sets of records at ones.

-- 01. Inserting a new record
-- Problem: You need to insert a new record, deptno = 50, ename = programming
-- and loc - baltimore.

insert into dept (detpno, dname, loc)
	values (50, 'Programming', 'Baltimore');

-- interestingly for DB2 and MySQL
/* Multiple row insert */
insert into dept (detpno, dname, loc)
	values (a, 'A', 'B'),
		   (2, 'B', 'C');

-- Discussion: The sytnax for inserting a single row is consistent across all
-- the database vendors!

-- As a shortcut, you can actually omit the column list in an insert statement:
insert into dept
values (50, 'Programming', 'Baltimore');

-- But if you don't list your target columns, you must insert into all the
-- columns and be mindful of the order in the value lists.

-- 02. Inserting default values
-- Problem: You want to insert the default value into a table

insert into D values (default);

-- If you are not inserting into all the columns of a table, you need 
-- to specify the column name.

insert into D (id) values (default);

-- MySQL has another option, to create the new table with default values!

create table d (id integer default 0, foo varchar(10));
insert into D (foo) values ('Bar');

-- Discussion: You don't have to include the non-default column in the insert 
-- list. ID takes on the default value because no other value is specified.

-- 03. Overriding a default value with NULL
-- Problem: You are inserting into a column with default value, and you wish
-- to override that default value by setting the column to NULL.

-- Consider this example:
create table D (id integer default 0, 
			    foo varchar(10));

-- Solution: You can explicitly specify null in your value list
insert into d (id, foo) values (null, 'Brighten');

	
