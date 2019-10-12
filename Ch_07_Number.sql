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

-- Finally, it is not a requirement to put deptno in your groupby.
-- But it is a requirement (or strong recommendation) to NOT put columns in
-- your select if they are not in groupby, calculations are excluded.

-- 02. Finding the min/max value in a column
-- Please find the highest and lowest values in a given column. Such as 
-- highest and lowest salary for all employees.

-- Solution: Simply use the min() and max() function respectively
select min(sal) as min_sal, max(sal) as max_sal
from emp;

/* Output:
+---------+---------+
| min_sal | max_sal |
+---------+---------+
|     950 |    5000 |
+---------+---------+
1 row in set (0.06 sec)
*/

-- When you want to get min and max for each department. You can use the 
-- groupby clause.

select deptno, min(sal) as min_sal, max(sal) as max_sal
from emp
group by deptno;

/* Output:
+--------+---------+---------+
| deptno | min_sal | max_sal |
+--------+---------+---------+
|     10 |    1300 |    5000 |
|     20 |     960 |    3600 |
|     30 |     950 |    2850 |
+--------+---------+---------+
3 rows in set (0.01 sec)
*/

-- Also as a reminder, the min/max ignores null value. If you have a min/max
-- that from a table with null values. Please replace the null with 0 first.
-- Otherwise it will returns a null as the min value.

select deptno, comm
from emp
where deptno in (10, 30)
order by 1;

/* Output:
+--------+------+
| deptno | comm |
+--------+------+
|     10 | NULL |
|     10 | NULL |
|     10 | NULL |
|     30 |  300 |
|     30 |  500 |
|     30 | 1400 |
|     30 | NULL |
|     30 |    0 |
|     30 | NULL |
+--------+------+
9 rows in set (0.01 sec)
*/

select deptno, min(comm), max(comm)
from emp
group by deptno;

/* Ouput:
+--------+-----------+-----------+
| deptno | min(comm) | max(comm) |
+--------+-----------+-----------+
|     10 |      NULL |      NULL |
|     20 |      NULL |      NULL |
|     30 |         0 |      1400 |
+--------+-----------+-----------+
3 rows in set (0.00 sec)
*/

-- 03. Summing the values in a column
-- Please compute the sum of all values, such as all employee salaries.

select sum(sal)
from emp;

-- If you need to sum by department, simply use groupby deptno.

select deptno, sum(sal) as total_for_dept
from emp
group by deptno;