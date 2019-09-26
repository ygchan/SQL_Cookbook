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

-- 04. Copying rows from one table into another
-- Problem: You want to query some rows, and then insert these rows into 
-- another table. 

insert into dept_east(deptno, dname, loc)
select deptno, dname, loc
from dept
where loc in ('New York', 'Boston');

-- George: You use the insert into keyword <table_name> (column_list)
--                     select ... from ... where
-- Simply follow the insert statement with a query that returns the desired
-- rows. If you want to copy the entire table, then write it without the where
-- clause.

-- 05. Copying a table definition
-- Problem: You want to copy the structure of the table, but not the data rows.

create table dept_2 as 
select *
from dept
where 1 = 0;

/* Output: 
mysql> create table dept_2 as 
    -> select *
    -> from dept
    -> where 1 = 0;
Query OK, 0 rows affected (0.16 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> select * from dept_2;
Empty set (0.01 sec)

mysql> desc dept_2;
+--------+-------------+------+-----+---------+-------+
| Field  | Type        | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| DEPTNO | int(11)     | YES  |     | NULL    |       |
| DNAME  | varchar(14) | YES  |     | NULL    |       |
| LOC    | varchar(13) | YES  |     | NULL    |       |
+--------+-------------+------+-----+---------+-------+
3 rows in set (0.03 sec)
*/

-- Discussion: 1 = 0 (that is not possible!)
-- No rows will be copied if you specify a false conditino (1 = 0) is going to 
-- be false on every row.

-- 06. Insert into multiple tables at once
-- MySQL does not support.

-- 07. Blocking insert for a particular rows
-- Problem: You don't want to allow user to insert a certain Field

-- Solution: Block them using views

-- 08. Modifying records in a table
-- Problem: You want to increase the salaries of everyone in the department 
-- by 20%.

select deptno, ename, sal
from emp
where deptno = 20
order by 1, 3;

/* Output:
+--------+-------+------+
| deptno | ename | sal  |
+--------+-------+------+
|     20 | SMITH |  800 |
|     20 | ADAMS | 1100 |
|     20 | JONES | 2975 |
|     20 | SCOTT | 3000 |
|     20 | FORD  | 3000 |
+--------+-------+------+
5 rows in set (0.01 sec)
*/

-- Solution: Use the update statement
update emp
   set sal = sal*1.20
   where deptno = 20; 

-- Discussion: If you do not include a where clause, then all rows will be
-- updated. You don't want to give EVERYONE in every department a raise right?

-- When you are doing a massive update, it is better to use a select statement
-- first. Like this one below to check what is the before/after effect.

select deptno,
   ename,
   sal as orig_sal,
   sal*.2 as amt_to_add,
   sal*1.2 as new_sal
from emp
where deptno = 20
order by 1, 5;

/* Output:
+--------+-------+----------+------------+---------+
| deptno | ename | orig_sal | amt_to_add | new_sal |
+--------+-------+----------+------------+---------+
|     20 | SMITH |      960 |      192.0 |  1152.0 |
|     20 | ADAMS |     1320 |      264.0 |  1584.0 |
|     20 | JONES |     3570 |      714.0 |  4284.0 |
|     20 | SCOTT |     3600 |      720.0 |  4320.0 |
|     20 | FORD  |     3600 |      720.0 |  4320.0 |
+--------+-------+----------+------------+---------+
5 rows in set (0.01 sec)
*/

-- 09. Updating when corresponding rows exits
-- Problem: Update the table when corresponding rows exists in another table.

update emp
set sal = sal*1.20
where empno in (select empno from emp_bonus);

-- Solution: Use a subquery to represents the rows that will be updated
-- in the table EMP. The in predicates test values of empno from emp table.

-- Alternatively (more complicated)
update emp
set sal = sal*1.20
where exits (select null
             from emp_bonus
             where emp.empno=emp_bonus.empno);

-- The author like this answer more, because select nulls has nothing to
-- do with exits, given the empno matches. 

-- 10. Updating values from another table
-- Problem: You want to update the commission from one table to another
-- if they matches by the rows, and 50% in the commission.

select deptno, ename, sal, comm
from emp
order by 1;

/* Output:
+--------+--------+------+------+
| deptno | ename  | sal  | comm |
+--------+--------+------+------+
|     10 | MILLER | 1300 | NULL |
|     10 | KING   | 5000 | NULL |
|     10 | CLARK  | 2450 | NULL |
|     20 | FORD   | 3600 | NULL |
|     20 | ADAMS  | 1320 | NULL |
|     20 | SCOTT  | 3600 | NULL |
|     20 | JONES  | 3570 | NULL |
|     20 | SMITH  |  960 | NULL |
|     30 | BLAKE  | 2850 | NULL |
|     30 | MARTIN | 1250 | 1400 |
|     30 | TURNER | 1500 |    0 |
|     30 | WARD   | 1250 |  500 |
|     30 | JAMES  |  950 | NULL |
|     30 | ALLEN  | 1600 |  300 |
+--------+--------+------+------+
14 rows in set (0.01 sec)
*/

-- Hinit: It is common to perform this update using coorelated subquery.
-- Another technique involes create a view (traditional or inline) and then
-- update that view.

update emp e, new_sal ns
set e.sal = ns.sal,
  e.comm = ns.sal/2
where e.deptno = ns.deptno;

-- Would this work for SAS? I must try this tomorrow!!
-- Note: A where caluse in the subquery (coorelated subquery) is not the same 
-- as the where clause of the table updated.

-- Coorelated subquery or synchronized subquery is a subquery (query nested
-- inside another query) that uses value from the outer query.

/* Example:
select employee_number, name
from employee emp
where salary > (
  select avg(salary)
  from employee
  where department = emp.department);
*/

-- But authoer quickly pointed out, if the new_salary does not have any 
-- other department, THEN they will set to NULL. (Oracle...)

-- MySQL, SQL Server this approach is fine.

-- 11. Merging Records (NA)

-- 12. Deleting all records from a table
-- Problem: Delete all records from a table.
delete from emp;

-- 13. Deleting specific records
delete from emp where deptno = 10;

-- 14. Deleting a single record
-- Problem: Delete a single primary key (specify only one)
delete from emp where empno = 7783;

-- Discussion, this gives more reason to have a primary key that is distinct
-- non-missing. Keep that in mind when you design your database schema.

-- Check first if your key is indeed unique. 

-- 15. Deleting referential integrity violations
-- Problem: Delete records that points to a non-existing deptno

delete from emp
where not exists(
  select * from dept
  where dept.detpno = emp.deptno
);

-- or you can use not in
delete from emp
where deptno not in (select deptno from dept);

-- 16. Deleting duplicate records
-- Problem: Remove any duplicates and keep only 1 copy

delete from dupes
where id not in (
select min(id)
from (select id, name from dupes) temp
group by name
);

-- I think this is the solution for PROC SQL.
-- You can not reference the same table twice in the delete.
-- Using this the data is returned in an inline view temp table.

-- Duplicate is consider as: 2 records w/ same value in their name column.
-- I think it is important to have id in every table as primary key.