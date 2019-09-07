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