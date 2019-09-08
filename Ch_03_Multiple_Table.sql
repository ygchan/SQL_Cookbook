-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Chapter 03: Working with multiple tables

-- 01: Stacking one data rowset atop another
select ename as ename_and_dname, deptno
from emp
where deptno = 10
union all
select '--------', '--------'
union all
select dname, deptno
from dept;

/* Output:
+-----------------+----------+
| ename_and_dname | deptno   |
+-----------------+----------+
| CLARK           | 10       |
| KING            | 10       |
| MILLER          | 10       |
| --------        | -------- |
| ACCOUNTING      | 10       |
| RESEARCH        | 20       |
| SALES           | 30       |
| OPERATIONS      | 40       |
+-----------------+----------+
8 rows in set (0.00 sec)
*/

-- Important Note: Union all will include duplicates if they exits
-- Union will filter out any duplicates.

-- Union is the same as select distinct.
-- If you know in advance there are no duplicates, then please use union all
-- for faster performance.

-- Source: c-sharpcorner.com
-- https://bit.ly/2k4Owzj

select deptno
from emp
union
select deptno
from emp;

-- This will remove any duplicates, I wonder how is SQL implemented in the back
-- Specifying union will most likely result in a sort operation in order to
-- eliminate duplicates. The query about is roughly equivalent to the following

select distinct 
from (
   select deptno
   from emp
   union all
   select deptno
   from emp
);

-- 02. Combining related rows
-- Problem: Get the data from multiple tables, display the name of all the
-- employees in department 10 along with the location of each employee's dept

select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno
   and e.deptno = 10;

/* Output:
+--------+----------+
| ename  | loc      |
+--------+----------+
| CLARK  | NEW YORK |
| KING   | NEW YORK |
| MILLER | NEW YORK |
+--------+----------+
3 rows in set (0.01 sec)
*/

-- Conceptually, the result set from a join is produced by first creating a
-- cartesian product (all possible combinations), and restrict the result
-- that matches the where expression.

-- equi-join: the join condition is based on an equality condition.
-- Use the join clause if you prefer to have the join logic in from clause
-- rather than the where clause.

-- 03. Finding rows in common between 2 tables
-- Problem: Another example of inner join

create view v as
select ename, job, sal
from emp
where job = 'CLERK';

select e.empno, e.ename, e.job, e.sal, e.deptno
from emp e 
   inner join v on (
      e.ename = v.ename
      and e.job = v.job
      and e.sal = v.sal
   )
;

/* Output:
+-------+--------+-------+------+--------+
| empno | ename  | job   | sal  | deptno |
+-------+--------+-------+------+--------+
|  7369 | SMITH  | CLERK |  800 |     20 |
|  7876 | ADAMS  | CLERK | 1100 |     20 |
|  7900 | JAMES  | CLERK |  950 |     30 |
|  7934 | MILLER | CLERK | 1300 |     10 |
+-------+--------+-------+------+--------+
4 rows in set (0.02 sec)
*/

-- 04. Retrieving values from one table that do not exist in another
-- Problem: Using not in () expression in where clause

-- Note: In DB2 you use set operation (except)
--       In Oracle you use set operation (minus)

-- This is MySQL solution
select deptno 
from dept
where deptno not in (select deptno from emp);

/* Output:
+--------+
| deptno |
+--------+
|     40 |
+--------+
1 row in set (0.01 sec)
*/

/*
(base) Georges-MacBook-Air:~ Study$ export PATH=$PATH:/usr/local/mysql/bin
(base) Georges-MacBook-Air:~ Study$ mysql -u Study -p bank
*/

select deptno
from dept
where deptno in (10, 50, null);

/* Output:
+--------+
| deptno |
+--------+
|     10 |
+--------+
1 row in set (0.01 sec)
*/

-- Note that the following Truth table:
-- T OR NULL  --> NULL
-- NOT (NULL) --> NULL
-- AND (NULL) --> NULL

-- You must keep this in mind in SQL, True or Null is True, but False or Null
-- is Null. You must keep this in mind when using in predicates and when 
-- performing logical or evaluation.

-- To avoid this problem with not in and nulls. Please use a coorelated 
-- subquery in conjunction with not exists. 

select d.deptno
from dept d
where not exists (
   select 1
   from emp e
   where d.deptno = e.deptno
);

/* Output:
+--------+
| deptno |
+--------+
|     40 |
+--------+
1 row in set (0.01 sec)
*/














