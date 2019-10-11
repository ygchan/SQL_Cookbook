-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Common operations with numbers, such as numeric computations.
-- Think about use of aggregate functions and the group by clause.

-- 01. Computing an average
-- Please compute the average salary for all employees
-- and average salary for each department.

-- Average salary for all employees
select avg(sal) avg_sal
from emp;

/* Output:
mysql> select avg(sal) from emp;
+-----------+
| avg_sal   |
+-----------+
| 2228.5714 |
+-----------+
1 row in set (0.02 sec)
*/

-- Average salary for each department
select deptno, avg(sal) as avg_sal
from emp
group by deptno;

/* Output:
+--------+-----------+
| deptno | avg_sal   |
+--------+-----------+
|     10 | 2916.6667 |
|     20 | 2610.0000 |
|     30 | 1566.6667 |
+--------+-----------+
3 rows in set (0.00 sec)
*/