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




















