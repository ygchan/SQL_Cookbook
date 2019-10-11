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

-- Discussion: It is important to note that the function avg ignores nulls
create table t2(sal integer);
insert into t2 values (10);
insert into t2 values (20);
insert into t2 values (null);

select avg(sal) from t2;
select distinct 30/2 from t2;

-- they both equal to t2. So the take away point is: avg() function will 
-- ignore null values and only consider 2 values in t2 sample table.

-- Author provided a tip to use coalesce function to handle this situation
-- for example, if you want to count missing value into average.
-- Then you would do avg(coalesec(sal, 0)).

select avg(coalesce(sal, 0)) avg_sal from t2;

/* Output:
+---------+
| avg_sal |
+---------+
| 10.0000 |
+---------+
1 row in set (0.00 sec)
*/